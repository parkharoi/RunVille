import { createClient } from "@supabase/supabase-js";

const supabaseUrl =
  process.env.SUPABASE_URL || "https://jswjljojkdvhypglzjch.supabase.co";
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseAnonKey) {
  throw new Error("SUPABASE_ANON_KEY is missing. Add it to your .env file.");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
