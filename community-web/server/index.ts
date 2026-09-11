import fastifyStatic from '@fastify/static';
import middie from '@fastify/middie';
import Fastify from 'fastify';
import { readFile } from 'node:fs/promises';
import { PassThrough } from 'node:stream';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { createServer as createViteServer, type ViteDevServer } from 'vite';
import type { RenderResult } from '../src/entry-server';

const root = process.cwd();
const isProduction = process.env.NODE_ENV === 'production';
const app = Fastify({ logger: true });
let vite: ViteDevServer | null = null;

if (isProduction) {
  await app.register(fastifyStatic, {
    root: join(root, 'dist/client'),
    wildcard: false,
  });
} else {
  vite = await createViteServer({ root, server: { middlewareMode: true }, appType: 'custom' });
  await app.register(middie);
  app.use(vite.middlewares);
}

app.get('/*', async (request, reply) => {
  const url = request.raw.url ?? '/cafe/neon8-seoul';

  try {
    let template: string;
    let render: (url: string) => Promise<RenderResult>;

    if (vite) {
      const rawTemplate = await readFile(join(root, 'index.html'), 'utf8');
      template = await vite.transformIndexHtml(url, rawTemplate);
      const module = await vite.ssrLoadModule('/src/entry-server.tsx');
      render = module.render as typeof render;
    } else {
      template = await readFile(join(root, 'dist/client/index.html'), 'utf8');
      const moduleUrl = pathToFileURL(join(root, 'dist/server/entry-server.js')).href;
      const module = await import(moduleUrl);
      render = module.render as typeof render;
    }

    const [head, tail] = template.split('<!--app-html-->');
    if (tail === undefined) throw new Error('index.html is missing <!--app-html-->');

    const result = await render(url);
    const state = JSON.stringify(result.dehydratedState).replace(/</g, '\\u003c');

    reply.hijack();
    const response = reply.raw;
    response.statusCode = 200;
    response.setHeader('Content-Type', 'text/html; charset=utf-8');
    response.setHeader('Transfer-Encoding', 'chunked');
    response.write(head);

    const body = new PassThrough();
    body.on('data', (chunk) => response.write(chunk));
    body.on('end', () => {
      response.write(`<script id="__TANSTACK_STATE__" type="application/json">${state}</script>`);
      response.end(tail);
    });
    body.on('error', (error) => {
      request.log.error(error);
      response.destroy(error);
    });

    result.pipe(body);
    const timeout = setTimeout(result.abort, 10_000);
    body.on('close', () => clearTimeout(timeout));
  } catch (error) {
    if (vite && error instanceof Error) vite.ssrFixStacktrace(error);
    request.log.error(error);
    if (!reply.sent) reply.code(500).type('text/plain').send('SSR render failed');
  }
});

await app.listen({ port: Number(process.env.PORT ?? 4173), host: '0.0.0.0' });
