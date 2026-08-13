/**
 * Embeds the standalone "Term 4 Bidding Q&A" HTML tool as-is (public/term4-bidding-qa.html)
 * via iframe — same pattern as TermFourDossier.tsx.
 */
export default function TermFourBiddingQA() {
  return (
    <iframe
      src="/term4-bidding-qa.html"
      title="Term 4 Bidding Q&A"
      style={{ width: "100%", height: "100vh", border: "none", display: "block" }}
    />
  );
}
