import js from "@eslint/js";
import globals from "globals";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import tseslint from "typescript-eslint";

/**
 * The repo has shipped eslint 9 and these four plugins as devDependencies since the start but
 * never had a config, so `npm run lint` failed on every invocation and CI skipped it (see the
 * comment this replaces in .github/workflows/ci.yml). This is the flat config they expect.
 */
export default tseslint.config(
  { ignores: ["dist", "supabase", "**/*.html"] },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2022,
      globals: globals.browser,
    },
    plugins: {
      "react-hooks": reactHooks,
      "react-refresh": reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      "react-refresh/only-export-components": ["warn", { allowConstantExport: true }],

      // The three below ship as errors in react-hooks v7, which encodes React Compiler's rules.
      // This app does not use the compiler, and every one of the ~25 hits is the load-then-setState
      // effect that each page and hook is built on — `set-state-in-effect` alone flags 20 sites
      // across the data hooks, the admin screens and the Learn pages. Turning them into hard
      // failures would mean either a rewrite of every data path in the app or a permanently red
      // CI, so they stay as warnings: the signal is kept and the command is usable.
      //
      // Worth revisiting as a deliberate piece of work — moving the load-on-mount effects onto a
      // fetching library, or adopting the compiler — rather than as a side effect of adding lint.
      "react-hooks/set-state-in-effect": "warn",
      "react-hooks/immutability": "warn",
      "react-hooks/purity": "warn",
    },
  },
  {
    // Config files run in Node, not the browser.
    files: ["*.config.{js,ts}"],
    languageOptions: { globals: globals.node },
  },
);
