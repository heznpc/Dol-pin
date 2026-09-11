import * as s from './styles.css';

export default function ChallengeCard() {
  return (
    <div className={s.challenge}>
      <div className={s.challengeKicker}>진행중 · 148명 참여</div>
      <h3 className={s.challengeTitle}>내 응원봉 인증샷 7일 챌린지</h3>
      <p className={s.small}>
        dol-pin의 물품 인증 맥락을 커뮤니티 참여로 확장한 카드예요. 오늘의 인증 사진을 올리고 공연 전 준비를 함께 점검합니다.
      </p>
      <a className={s.action} href="/cafe/neon8-seoul?board=media">인증글 보기</a>
    </div>
  );
}
