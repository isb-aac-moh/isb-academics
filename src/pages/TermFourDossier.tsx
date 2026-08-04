/**
 * Embeds the standalone "Term Four Dossier" HTML tool as-is (public/term4-dossier.html)
 * via iframe — not part of the app's design system on purpose, and not touched.
 */
export default function TermFourDossier() {
  return (
    <iframe
      src="/term4-dossier.html"
      title="Term 4 Dossier"
      style={{ width: "100%", height: "100vh", border: "none", display: "block" }}
    />
  );
}
