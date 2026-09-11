export type BoardKey = 'all' | 'notice' | 'schedule' | 'concert' | 'media' | 'rental' | 'talk';

export type CommunityPost = {
  id: string;
  board: Exclude<BoardKey, 'all'>;
  title: string;
  excerpt: string;
  author: string;
  authorArea: string;
  createdAt: string;
  views: number;
  likes: number;
  comments: number;
  pinned?: boolean;
  locked?: boolean;
  imageTone?: 'violet' | 'blue' | 'pink' | 'lime';
};

export const boards: Array<{ key: BoardKey; label: string }> = [
  { key: 'all', label: '전체' },
  { key: 'notice', label: '공지' },
  { key: 'schedule', label: '소식·스케줄' },
  { key: 'concert', label: '공연정보' },
  { key: 'media', label: '직찍·직캠' },
  { key: 'rental', label: '대여후기' },
  { key: 'talk', label: '자유수다' },
];

export const cafe = {
  slug: 'neon8-seoul',
  name: 'NEON8 서울 핀카페',
  tagline: '공연 전 준비부터 끝난 뒤의 후기까지, 같은 최애를 좋아하는 사람들과 연결되는 곳',
  region: '서울',
  category: '방송·연예',
  members: 1284,
  posts: 3129,
  lastActive: '3분 전',
  concert: {
    title: 'NEON8 ECHOES WORLD TOUR — SEOUL',
    venue: 'KSPO DOME',
    date: '2026.10.03',
    dday: 'D-22',
  },
  notices: [
    '공연 당일 대여 물품은 수령 시간을 꼭 확인해주세요',
    '직찍·직캠 게시판 업로드 가이드',
  ],
  album: [
    { label: '출국길', tone: 'violet' },
    { label: '막콘 엔딩', tone: 'pink' },
    { label: '사운드체크', tone: 'blue' },
    { label: '응원봉 물결', tone: 'lime' },
  ],
};

export const posts: CommunityPost[] = [
  {
    id: 'concert-checklist',
    board: 'notice',
    title: '서울콘 준비물 체크리스트 — 대여/수령 동선 포함',
    excerpt: '응원봉, 보조배터리, 망원경, 우비까지 공연 전날 마지막으로 확인할 목록을 정리했어요.',
    author: '핀지기',
    authorArea: '서울 송파구',
    createdAt: '20분 전',
    views: 1248,
    likes: 91,
    comments: 24,
    pinned: true,
  },
  {
    id: 'tour-schedule',
    board: 'schedule',
    title: 'ECHOES TOUR 아시아 일정 한 장 정리',
    excerpt: '서울 이후 자카르타, 도쿄, 오사카 일정과 티켓 오픈일을 같이 정리했습니다.',
    author: 'orbit8',
    authorArea: '서울 마포구',
    createdAt: '42분 전',
    views: 822,
    likes: 63,
    comments: 18,
  },
  {
    id: 'kspro-pickup',
    board: 'concert',
    title: 'KSPO DOME 2호선 기준 물품 수령하기 편한 위치',
    excerpt: '대여 약속 잡을 때 5호선/9호선 환승까지 고려하면 이쪽이 덜 붐볐습니다.',
    author: 'bluehour',
    authorArea: '서울 강동구',
    createdAt: '1시간 전',
    views: 639,
    likes: 47,
    comments: 31,
  },
  {
    id: 'soundcheck-photos',
    board: 'media',
    title: '오늘 사운드체크 자리 시야 공유',
    excerpt: '2층 중앙 기준 무대 전체가 잘 보였고 돌출 들어올 때는 망원경 없어도 괜찮았어요.',
    author: 'mintpin',
    authorArea: '서울 성동구',
    createdAt: '1시간 전',
    views: 1981,
    likes: 188,
    comments: 44,
    imageTone: 'blue',
  },
  {
    id: 'lightstick-rental-review',
    board: 'rental',
    title: '공식 응원봉 3세대 대여 후기 — 배터리 상태까지 확인함',
    excerpt: 'dol-pin에서 빌렸는데 수령 전에 사진 비교가 있어서 상태 확인하기 편했어요.',
    author: 'day8',
    authorArea: '경기 성남시',
    createdAt: '2시간 전',
    views: 511,
    likes: 39,
    comments: 12,
    imageTone: 'violet',
  },
  {
    id: 'after-party-talk',
    board: 'talk',
    title: '막콘 끝나고 다들 뭐 먹을 예정?',
    excerpt: '공연장 근처 늦게까지 하는 곳 있으면 추천 부탁해요. 혼밥 가능한 곳이면 더 좋음.',
    author: 'n8zip',
    authorArea: '서울 광진구',
    createdAt: '3시간 전',
    views: 302,
    likes: 21,
    comments: 56,
  },
  {
    id: 'members-only-trade',
    board: 'talk',
    title: '카페 멤버 전용: 포토카드 현장 교환 스레드',
    excerpt: '가입 멤버에게만 공개되는 게시글입니다.',
    author: '핀지기',
    authorArea: '서울 송파구',
    createdAt: '4시간 전',
    views: 214,
    likes: 16,
    comments: 33,
    locked: true,
  },
];

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export async function getCafe() {
  await delay(20);
  return cafe;
}

export async function getPosts(board: BoardKey = 'all') {
  await delay(35);
  return board === 'all' ? posts : posts.filter((post) => post.board === board);
}

export async function getPost(id: string) {
  await delay(25);
  return posts.find((post) => post.id === id) ?? null;
}
