"""
Generate machine-generated isiZulu and English text using Gemma 4 via Google AI.
Resumes from where it left off if interrupted.

Usage: 
  export GEMINI_API_KEY=your-api-key-here
  python3 generate_machine_text.py
"""
import json
import csv
import time
import os
from google import genai

client = genai.Client()

with open('zul_cues.json') as f:
    cues = json.load(f)

prompt_templates = [
    "Write a short paragraph (3-5 sentences) in {lang} about: {title}\nContext: {snippet}\nWrite naturally as if for a newspaper. Only output the paragraph.",
    "In {lang}, write 3-4 sentences summarising this topic: {title}\nBackground: {snippet}\nBe informative and clear. Only output the text.",
    "Compose a short {lang} news-style paragraph about: {title}\nDetails: {snippet}\nKeep it factual, 3-5 sentences. Only output the paragraph.",
    "In {lang}, produce a short educational paragraph (3-5 sentences) on: {title}\nContext: {snippet}\nOnly output the paragraph.",
]

output_file = 'machine_generated_gemini.csv'

# Check how many cues already done (8 rows per cue)
start_cue = 0
count = 0
if os.path.exists(output_file):
    with open(output_file, 'r') as f:
        existing = sum(1 for _ in f) - 1  # minus header
    start_cue = existing // 8
    count = existing
    print(f"Resuming from cue {start_cue + 1}/185 ({count} samples already done)", flush=True)

mode = 'a' if start_cue > 0 else 'w'
errors = 0

with open(output_file, mode, newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['text', 'language', 'source', 'model', 'topic'])
    if mode == 'w':
        writer.writeheader()

    for i, cue in enumerate(cues):
        if i < start_cue:
            continue

        title = cue['title']
        snippet = cue['snippet'][:200]

        for j, template in enumerate(prompt_templates):
            for lang_code, lang_name in [('zul', 'isiZulu'), ('eng', 'English')]:
                prompt = template.format(lang=lang_name, title=title, snippet=snippet)

                for attempt in range(3):
                    try:
                        response = client.models.generate_content(
                            model='gemma-4-26b-a4b-it',
                            contents=prompt
                        )
                        text = response.text.strip()
                        if len(text.split()) >= 20:
                            writer.writerow({
                                'text': text,
                                'language': lang_code,
                                'source': 'machine',
                                'model': 'gemma-4-26b-a4b-it',
                                'topic': title
                            })
                            f.flush()
                            count += 1
                            print(f"  ✓ {lang_code} t{j+1} | Total: {count}", flush=True)
                        break
                    except Exception as e:
                        errors += 1
                        if '429' in str(e) or '503' in str(e):
                            print(f"  ⏳ Rate limited, waiting 60s (attempt {attempt+1}/3)...", flush=True)
                            time.sleep(60)
                        else:
                            print(f"  ✗ Error: {str(e)[:80]}", flush=True)
                            time.sleep(5)
                            break

                time.sleep(4)

        print(f"\n[{i+1}/{len(cues)}] Done | Generated: {count} | Errors: {errors}\n", flush=True)

print(f"\nComplete! Generated {count} samples saved to {output_file}")
