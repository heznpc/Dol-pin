import { HydrationBoundary, QueryClient, QueryClientProvider, useQuery, type DehydratedState } from '@tanstack/react-query';
import { lazy, Suspense, useState } from 'react';
import { boards, getCafe, getPost, getPosts, type BoardKey, type CommunityPost } from './data';
import * as s from './styles.css';

const ChallengeCard = lazy(async () => {
  // Intentional lab delay: makes the Suspense boundary observable in the HTML stream.
  await new Promise((resolve) => setTimeout(resolve, 450));
  return import('./ChallengeCard');
});

type AppRootProps = {
  queryClient: QueryClient;
  dehydratedState: DehydratedState;
  url: string;
};

type Route =
  | { kind: 'home'; slug: string; board: BoardKey }
  | { kind: 'post'; slug: string; postId: string }
  | { kind: 'not-found' };

export function parseRoute(rawUrl: string): Route {
  const url = new URL(rawUrl, 'http://dolpin.local');
  const parts = url.pathname.split('/').filter(Boolean);
  if (parts[0] !== 'cafe' || !parts[1]) return { kind: 'not-found' };
  if (parts[2] === 'posts' && parts[3]) return { kind: 'post', slug: parts[1], postId: parts[3] };
  const board = (url.searchParams.get('board') ?? 'all') as BoardKey;
  const valid = boards.some((item) => item.key === board);
  return { kind: 'home', slug: parts[1], board: valid ? board : 'all' };
}

export function AppRoot({ queryClient, dehydratedState, url }: AppRootProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <HydrationBoundary state={dehydratedState}>
        <App url={url} />
      </HydrationBoundary>
    </QueryClientProvider>
  );
}

function App({ url }: { url: string }) {
  const route = parseRoute(url);
  return (
    <div className={s.shell}>
      <header className={s.topbar}>
        <div className={s.topbarInner}>
          <a className={s.brand} href="/cafe/neon8-seoul">dol-pin<span className={s.brandDot}>/community</span></a>
          <nav className={s.nav} aria-label="주요 메뉴">
            <a href="/cafe/neon8-seoul">카페</a>
            <a href="/cafe/neon8-seoul?board=concert">공연</a>
            <a href="/cafe/neon8-seoul?board=rental">대여후기</a>
          </nav>
        </div>
      </header>
      <main className={s.main}>
        {route.kind === 'home' && <CafeHome slug={route.slug} board={route.board} />}
        {route.kind === 'post' && <PostDetail slug={route.slug} postId={route.postId} />}
        {route.kind === 'not-found' && <div className={s.empty}>찾을 수 없는 페이지입니다.</div>}
      </main>
    </div>
  );
}

function CafeHome({ slug, board }: { slug: string; board: BoardKey }) {
  const cafeQuery = useQuery({ queryKey: ['cafe', slug], queryFn: getCafe });
  const postsQuery = useQuery({ queryKey: ['posts', slug, board], queryFn: () => getPosts(board) });
  const cafe = cafeQuery.data;
  const posts = postsQuery.data ?? [];

  if (!cafe) return <div className={s.empty}>카페 정보를 불러오는 중입니다.</div>;

  return (
    <div className={s.twoColumn}>
      <div className={s.card}>
        <section className={s.hero}>
          <div className={s.eyebrow}>{cafe.region} · {cafe.category}</div>
          <h1 className={s.heroTitle}>{cafe.name}</h1>
          <p className={s.heroCopy}>{cafe.tagline}</p>
          <div className={s.stats}>
            <span className={s.stat}>멤버 {cafe.members.toLocaleString()}명</span>
            <span className={s.stat}>게시글 {cafe.posts.toLocaleString()}개</span>
            <span className={s.stat}>{cafe.lastActive} 활동</span>
          </div>
          <div className={s.concert}>
            <div>
              <div className={s.eyebrow}>다가오는 공연 · {cafe.concert.date}</div>
              <div className={s.concertTitle}>{cafe.concert.title}</div>
              <div className={s.small}>{cafe.concert.venue}</div>
            </div>
            <div className={s.dday}>{cafe.concert.dday}</div>
          </div>
        </section>

        <section className={s.section}>
          <h2 className={s.sectionTitle}>공지</h2>
          <ul className={s.noticeList}>
            {cafe.notices.map((notice) => (
              <li className={s.notice} key={notice}><span className={s.pin}>PIN</span>{notice}</li>
            ))}
          </ul>
        </section>

        <section className={s.section}>
          <h2 className={s.sectionTitle}>앨범</h2>
          <div className={s.album}>
            {cafe.album.map((item) => <div className={`${s.albumItem} ${toneClass(item.tone)}`} key={item.label}>{item.label}</div>)}
          </div>
        </section>

        <section className={s.section}>
          <div className={s.boardTabs} aria-label="게시판 필터">
            {boards.map((item) => (
              <a
                key={item.key}
                className={`${s.tab} ${item.key === board ? s.activeTab : ''}`}
                href={item.key === 'all' ? `/cafe/${slug}` : `/cafe/${slug}?board=${item.key}`}
              >
                {item.label}
              </a>
            ))}
          </div>
          <div className={s.feed}>
            {posts.length === 0 ? <div className={s.empty}>아직 게시글이 없습니다.</div> : posts.map((post) => <PostRow key={post.id} post={post} slug={slug} />)}
          </div>
        </section>
      </div>

      <aside className={s.sideStack}>
        <div className={s.sideCard}>
          <h2 className={s.sideTitle}>오늘의 핀</h2>
          <Suspense fallback={<div className={s.challenge}><div className={s.small}>챌린지를 불러오는 중…</div></div>}>
            <ChallengeCard />
          </Suspense>
        </div>
        <div className={s.sideCard}>
          <h2 className={s.sideTitle}>dol-pin에서 이어졌어요</h2>
          <p className={s.small}>공연별 물품 탐색과 대여 후기가 커뮤니티의 공연정보·대여후기 게시판으로 이어집니다.</p>
          <a className={s.action} href="/cafe/neon8-seoul?board=rental">대여후기 보기</a>
        </div>
      </aside>
    </div>
  );
}

function PostRow({ post, slug }: { post: CommunityPost; slug: string }) {
  return (
    <article className={s.post}>
      <div>
        <h3 className={s.postTitle}>
          {post.pinned && <span className={s.badge}>공지</span>}
          {post.locked && <span className={s.badge}>멤버전용</span>}
          <a href={`/cafe/${slug}/posts/${post.id}`}>{post.title}</a>
        </h3>
        <p className={s.postExcerpt}>{post.excerpt}</p>
        <div className={s.meta}>
          <span>{post.author}</span><span>{post.createdAt}</span><span>조회 {post.views}</span><span>좋아요 {post.likes}</span><span>댓글 {post.comments}</span>
        </div>
      </div>
      {post.imageTone && <div className={`${s.thumb} ${toneClass(post.imageTone)}`} aria-label="게시글 이미지 미리보기" />}
    </article>
  );
}

function PostDetail({ slug, postId }: { slug: string; postId: string }) {
  const query = useQuery({ queryKey: ['post', slug, postId], queryFn: () => getPost(postId) });
  const post = query.data;
  const [liked, setLiked] = useState(false);

  if (!post) return <div className={s.empty}>게시글을 찾을 수 없습니다.</div>;
  const boardLabel = boards.find((item) => item.key === post.board)?.label ?? post.board;
  return (
    <>
      <a className={s.detailBack} href={`/cafe/${slug}`}>← 카페로 돌아가기</a>
      <article className={s.detail}>
        <span className={s.badge}>{boardLabel}</span>
        <h1 className={s.detailTitle}>{post.title}</h1>
        <div className={s.author}>{post.author} · {post.authorArea} · {post.createdAt} · 조회 {post.views}</div>
        <div className={s.body}>
          {`${post.excerpt}\n\n공연을 준비하면서 직접 확인한 내용을 카페 멤버들과 공유합니다. 필요한 정보는 댓글로 계속 보완할게요.\n\n대여 물품을 이용한 경우에는 수령 전후 사진과 실제 사용 경험을 중심으로 남겨주세요.`}
        </div>
        {post.imageTone && <div className={`${s.detailImage} ${toneClass(post.imageTone)}`} />}
        <div className={s.reactionRow}>
          <button className={s.likeButton} onClick={() => setLiked((value) => !value)} type="button">♥ {post.likes + (liked ? 1 : 0)}</button>
          <span className={s.small}>댓글 {post.comments}</span>
        </div>
        <div className={s.comment}><strong>pinmate</strong><br />이 정보 덕분에 동선 정리했어요. 공연 당일에도 업데이트 부탁해요!</div>
        <div className={s.comment}><strong>violet8</strong><br />대여 수령 위치까지 같이 적혀 있어서 좋네요.</div>
      </article>
    </>
  );
}

function toneClass(tone: string) {
  if (tone === 'pink') return s.tonePink;
  if (tone === 'blue') return s.toneBlue;
  if (tone === 'lime') return s.toneLime;
  return s.toneViolet;
}
