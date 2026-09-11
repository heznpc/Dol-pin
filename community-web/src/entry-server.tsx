import { QueryClient, dehydrate, type DehydratedState } from '@tanstack/react-query';
import { renderToPipeableStream } from 'react-dom/server';
import { AppRoot, parseRoute } from './App';
import { getCafe, getPost, getPosts } from './data';

export type RenderResult = {
  pipe: (destination: NodeJS.WritableStream) => void;
  abort: () => void;
  dehydratedState: DehydratedState;
};

export async function render(url: string): Promise<RenderResult> {
  const route = parseRoute(url);
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { staleTime: 30_000, retry: false },
    },
  });

  if (route.kind === 'home') {
    await Promise.all([
      queryClient.prefetchQuery({ queryKey: ['cafe', route.slug], queryFn: getCafe }),
      queryClient.prefetchQuery({ queryKey: ['posts', route.slug, route.board], queryFn: () => getPosts(route.board) }),
    ]);
  }
  if (route.kind === 'post') {
    await queryClient.prefetchQuery({ queryKey: ['post', route.slug, route.postId], queryFn: () => getPost(route.postId) });
  }

  const dehydratedState = dehydrate(queryClient);

  return new Promise((resolve, reject) => {
    const stream = renderToPipeableStream(
      <AppRoot queryClient={queryClient} dehydratedState={dehydratedState} url={url} />,
      {
        onShellReady() {
          resolve({
            pipe: stream.pipe,
            abort: stream.abort,
            dehydratedState,
          });
        },
        onShellError(error) {
          reject(error);
        },
        onError(error) {
          console.error('[ssr]', error);
        },
      },
    );
  });
}
