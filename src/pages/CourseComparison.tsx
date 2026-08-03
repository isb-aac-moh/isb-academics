/**
 * Embeds the standalone "Build Your Slate" HTML tool as-is (public/term4-course-comparison.html)
 * via iframe — not part of the app's design system on purpose, and not touched.
 */
export default function CourseComparison() {
  return (
    <iframe
      src="/term4-course-comparison.html"
      title="Term 4 Course Comparison"
      style={{ width: "100%", height: "100vh", border: "none", display: "block" }}
    />
  );
}
