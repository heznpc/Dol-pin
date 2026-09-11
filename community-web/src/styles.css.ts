import { globalStyle, style } from '@vanilla-extract/css';

globalStyle('*', { boxSizing: 'border-box' });
globalStyle('html', { background: '#f6f7f9' });
globalStyle('body', {
  margin: 0,
  fontFamily: 'Inter, Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
  color: '#171719',
  background: '#f6f7f9',
});
globalStyle('a', { color: 'inherit', textDecoration: 'none' });
globalStyle('button', { font: 'inherit' });

export const shell = style({ minHeight: '100vh' });
export const topbar = style({
  position: 'sticky', top: 0, zIndex: 10, backdropFilter: 'blur(14px)',
  background: 'rgba(255,255,255,.88)', borderBottom: '1px solid #ececef',
});
export const topbarInner = style({
  width: 'min(1080px, calc(100% - 32px))', margin: '0 auto', height: 64,
  display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 16,
});
export const brand = style({ fontSize: 18, fontWeight: 900, letterSpacing: '-0.04em' });
export const brandDot = style({ color: '#6c4cf1' });
export const nav = style({ display: 'flex', gap: 16, fontSize: 14, color: '#62626a' });
export const main = style({ width: 'min(1080px, calc(100% - 32px))', margin: '28px auto 64px' });
export const twoColumn = style({
  display: 'grid', gridTemplateColumns: 'minmax(0, 1fr) 300px', gap: 20,
  '@media': { '(max-width: 860px)': { gridTemplateColumns: '1fr' } },
});
export const card = style({ background: '#fff', border: '1px solid #e9e9ee', borderRadius: 22, overflow: 'hidden' });
export const hero = style({
  padding: 28,
  background: 'linear-gradient(135deg, #121217 0%, #262038 55%, #684df4 140%)',
  color: '#fff',
});
export const eyebrow = style({ fontSize: 12, fontWeight: 800, letterSpacing: '.08em', textTransform: 'uppercase', opacity: .7 });
export const heroTitle = style({ margin: '10px 0 8px', fontSize: 32, lineHeight: 1.15, letterSpacing: '-.04em' });
export const heroCopy = style({ margin: 0, maxWidth: 650, lineHeight: 1.6, color: '#d9d7e1' });
export const stats = style({ display: 'flex', flexWrap: 'wrap', gap: 10, marginTop: 20 });
export const stat = style({ padding: '8px 11px', borderRadius: 999, background: 'rgba(255,255,255,.1)', fontSize: 13 });
export const concert = style({ marginTop: 22, padding: 16, borderRadius: 16, background: 'rgba(255,255,255,.08)', display: 'flex', justifyContent: 'space-between', gap: 16, alignItems: 'center' });
export const concertTitle = style({ fontWeight: 800, marginTop: 4 });
export const dday = style({ flex: '0 0 auto', padding: '8px 10px', borderRadius: 12, background: '#fff', color: '#171719', fontWeight: 900 });
export const section = style({ padding: 22 });
export const sectionTitle = style({ margin: '0 0 14px', fontSize: 18, letterSpacing: '-.02em' });
export const noticeList = style({ margin: 0, padding: 0, listStyle: 'none', display: 'grid', gap: 10 });
export const notice = style({ display: 'flex', gap: 9, alignItems: 'center', fontSize: 14 });
export const pin = style({ color: '#6c4cf1', fontWeight: 900 });
export const album = style({ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10, '@media': { '(max-width: 640px)': { gridTemplateColumns: 'repeat(2, 1fr)' } } });
export const albumItem = style({ minHeight: 112, borderRadius: 16, padding: 12, display: 'flex', alignItems: 'flex-end', color: '#fff', fontWeight: 800, fontSize: 13 });
export const toneViolet = style({ background: 'linear-gradient(145deg,#8b6ff7,#3d2d91)' });
export const tonePink = style({ background: 'linear-gradient(145deg,#ff9eb4,#9f3d63)' });
export const toneBlue = style({ background: 'linear-gradient(145deg,#78b7ff,#3158a6)' });
export const toneLime = style({ background: 'linear-gradient(145deg,#b8e967,#5f7f20)' });
export const boardTabs = style({ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4, scrollbarWidth: 'none' });
export const tab = style({ flex: '0 0 auto', padding: '9px 12px', borderRadius: 999, background: '#f3f3f6', color: '#65656d', fontSize: 13, fontWeight: 700 });
export const activeTab = style({ background: '#171719', color: '#fff' });
export const feed = style({ display: 'grid' });
export const post = style({ padding: '18px 0', borderBottom: '1px solid #efeff2', display: 'grid', gridTemplateColumns: '1fr auto', gap: 16 });
export const postTitle = style({ margin: 0, fontSize: 16, lineHeight: 1.45, letterSpacing: '-.02em' });
export const postExcerpt = style({ margin: '7px 0 10px', color: '#6b6b73', fontSize: 14, lineHeight: 1.55 });
export const meta = style({ display: 'flex', flexWrap: 'wrap', gap: 8, color: '#97979e', fontSize: 12 });
export const badge = style({ display: 'inline-flex', marginRight: 6, padding: '3px 7px', borderRadius: 7, background: '#eee9ff', color: '#5c3fd7', fontSize: 11, fontWeight: 800 });
export const thumb = style({ width: 92, height: 76, borderRadius: 14, '@media': { '(max-width: 520px)': { width: 72, height: 72 } } });
export const sideStack = style({ display: 'grid', alignContent: 'start', gap: 16 });
export const sideCard = style({ padding: 20, background: '#fff', border: '1px solid #e9e9ee', borderRadius: 20 });
export const sideTitle = style({ margin: '0 0 12px', fontSize: 15 });
export const challenge = style({ padding: 16, borderRadius: 16, background: '#f3efff' });
export const challengeKicker = style({ color: '#6746df', fontSize: 12, fontWeight: 900 });
export const challengeTitle = style({ margin: '6px 0 8px', fontSize: 17, lineHeight: 1.35 });
export const small = style({ color: '#777780', fontSize: 13, lineHeight: 1.5 });
export const action = style({ display: 'inline-flex', marginTop: 12, padding: '9px 12px', borderRadius: 10, background: '#171719', color: '#fff', fontSize: 13, fontWeight: 800 });
export const detailBack = style({ display: 'inline-flex', marginBottom: 14, color: '#6e6e76', fontSize: 14 });
export const detail = style({ padding: 28, background: '#fff', border: '1px solid #e9e9ee', borderRadius: 22 });
export const detailTitle = style({ margin: '8px 0 14px', fontSize: 28, lineHeight: 1.3, letterSpacing: '-.04em' });
export const author = style({ paddingBottom: 18, borderBottom: '1px solid #efeff2', color: '#75757d', fontSize: 13 });
export const body = style({ padding: '26px 0', fontSize: 16, lineHeight: 1.8, whiteSpace: 'pre-line' });
export const detailImage = style({ minHeight: 300, borderRadius: 18, margin: '4px 0 24px' });
export const reactionRow = style({ display: 'flex', gap: 10, alignItems: 'center', paddingTop: 18, borderTop: '1px solid #efeff2' });
export const likeButton = style({ border: 0, cursor: 'pointer', padding: '10px 14px', borderRadius: 12, background: '#f1edff', color: '#5d3ed8', fontWeight: 900 });
export const comment = style({ padding: '14px 0', borderBottom: '1px solid #f0f0f3', fontSize: 14, lineHeight: 1.55 });
export const empty = style({ padding: '36px 0', textAlign: 'center', color: '#888890' });
