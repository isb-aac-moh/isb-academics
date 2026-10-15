# Task: write "What to know" blocks for Compass ideas
Input: ~/Downloads/compass-build/work/know/in_<N>.json (list of ideas: id, title, definition, question, evidence = short notes of where ISB courses covered it).
Output: ~/Downloads/compass-build/work/know/out_<N>.jsonl, one JSON object per input idea, same order:
{"id": "...", "what": "1-2 plain sentences: what the idea is", "use": "1 sentence: when/why you would use it (a decision or situation)", "trap": "1 sentence: a common mistake or limit", "ask": "one question to test yourself"}
Rules:
- Ground it ONLY in the given definition, question and evidence notes plus standard textbook knowledge you are sure of. If unsure, be general rather than specific. No invented numbers, names, or case facts.
- Never quote or paraphrase closely from the evidence notes. Do not mention professors, slides, or session numbers.
- Plain words, a smart non-expert reads it. No jargon without a short explanation. No filler like "crucial", "robust", "leverage", "delve", "landscape". No em-dash chains.
- Write the file with a small python script that json.dumps each record (do not hand-edit JSON). Validate: one line per input id, all four fields non-empty. Work in your own scratchpad for any helper scripts; write only your out file.
