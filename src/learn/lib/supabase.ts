// The learning app used to own its Supabase client. Now it shares the app's one, which is
// what makes a single login cover both halves — two createClient calls would mean two auth
// sessions against the same project and a student signed into one but not the other.
//
// Kept as a re-export rather than rewriting every import inside src/learn, so the ported
// files stay diffable against the original project.
export { supabase } from "../../lib/supabase";
