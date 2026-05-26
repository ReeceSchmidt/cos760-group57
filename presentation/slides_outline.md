# COS760 Group 57 — Presentation Outline
# Cross-Lingual Detection of Machine-Generated Text in isiZulu

## Slide Structure (5 minutes total)

---

## Slide 1: Title (15 sec)
- Title: Cross-Lingual Detection of Machine-Generated Text in isiZulu
- Subtitle: Using Transfer Learning and Explainability Analysis
- Group 57 | COS760 | University of Pretoria
- Member names

---

## Slide 2: Problem & Motivation (45 sec)
- LLMs can now generate fluent text in many languages
- isiZulu: 12M+ speakers, low-resource language
- Risk: academic fraud, misinformation, fake content in isiZulu
- Gap: No existing MGT detection research for isiZulu
- Our contribution: First MGT detector for isiZulu + explainability

---

## Slide 3: Research Questions (20 sec)
- RQ1: How accurately can fine-tuned AfroXLMR detect machine-generated isiZulu text?
- RQ2: Does an English-trained classifier transfer to isiZulu? What does LIME reveal?

---

## Slide 4: Data Pipeline (45 sec)
- Human text: Vukuzenzele + Wikipedia (isiZulu), News + Wikipedia (English)
- Machine text: Gemma 4 (26B) — 185 cues × 4 templates × 2 languages
- Cleaning: 4-sentence chunks, ≥30 words
- Splits: 70/15/15 — isiZulu, English, Combined
- Show sample counts

---

## Slide 5: Models & Method (45 sec)
- AfroXLMR-base: Multilingual + African language pretraining
- XLM-RoBERTa-base: General multilingual baseline
- 4 configs: isiZulu-only, English-only, Combined, Cross-lingual
- Training: lr=2e-5, batch=16, max_len=256, early stopping
- LIME for explainability

---

## Slide 6: Results Table (45 sec)
- Show results table (all configs, both models)
- Highlight: AfroXLMR > XLM-R on isiZulu
- Highlight: Cross-lingual drop (the key finding)
- Majority baseline comparison

---

## Slide 7: LIME Analysis (45 sec)
- Show LIME feature comparison figure
- isiZulu model: morphological features (prefixes, suffixes)
- Cross-lingual model: surface patterns (punctuation, numbers)
- Feature overlap: Jaccard similarity = X.XX
- Interpretation: language-specific features matter

---

## Slide 8: Conclusion & Future Work (20 sec)
- AfroXLMR effectively detects MGT in isiZulu (F1 = X.XX)
- Cross-lingual transfer works but is limited
- LIME reveals different detection strategies per model
- Future: more generators, more African languages, larger datasets

---

## Q&A Preparation Topics
- Why Gemma 4 instead of GPT-4?
- Why 4-sentence chunks?
- How would this work in production?
- Limitations of LIME for subword tokenizers?
- Why not DetectGPT?
- How does agglutinative morphology affect detection?
- Would more training data improve cross-lingual transfer?
