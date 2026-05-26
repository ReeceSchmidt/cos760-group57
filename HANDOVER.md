# COS 760 Group 57 — Project Handover Document

**Project:** Cross-Lingual Detection of Machine-Generated Text in isiZulu Using Transfer Learning and Explainability Analysis  
**Date:** 22 May 2026  
**Deadline:** 27 May 2026 (Report + Code), 15 June 2026 (Video), 17 June 2026 (Live Presentation)

---

## 1. Project Summary

Binary classification of human-written vs machine-generated text in isiZulu and English. We fine-tune AfroXLMR and compare cross-lingual transfer (English→isiZulu). LIME explainability analysis reveals which linguistic features drive detection in each language.

**Research Questions:**
1. How accurately can fine-tuned AfroXLMR detect machine-generated isiZulu text?
2. Does an English-trained classifier transfer to isiZulu, and what does LIME reveal about cross-lingual detection features?

**Repository:** https://github.com/ReeceSchmidt/cos760-group57

---

## 2. What's Done ✅

### Data Pipeline (Complete)
- **Human text collected:** isiZulu from Vukuzenzele/Wikipedia (`zul.csv`), English (`eng.csv`)
- **Human text cleaned:** Chunked into 4-sentence segments ≥30 words (`human_zul_cleaned.csv`, `human_eng_cleaned.csv`)
- **Machine text generated:** Gemma 4 (gemma-4-26b-a4b-it) via Google AI, 4 prompt templates × 185 cues × 2 languages (`machine_generated_gemini.csv`)
- **Train/Val/Test splits created:**
  - `combined_train.csv` / `combined_val.csv` / `combined_test.csv` (both languages)
  - `eng_train.csv` / `eng_val.csv` / `eng_test.csv`
  - `zul_train.csv` / `zul_val.csv` / `zul_test.csv`
- **Format:** CSV with columns `text, language, source, label` (0=human, 1=machine)

### Training Notebooks (Complete)
- `notebooks/AfroXLMR_Colab.ipynb` — Fine-tunes `Davlan/afro-xlmr-base` (4 configs)
- `notebooks/XLMR_Colab.ipynb` — Fine-tunes `xlm-roberta-base` (4 configs)
- Both ready to run on Google Colab with T4 GPU

### LIME Notebook (Complete)
- `notebooks/LIME_Analysis.ipynb` — Runs LIME on saved model checkpoints, generates feature importance comparisons

### Report Template (Complete)
- `report/main.typ` — Typst file using ACL format (tracl package), all sections written, `#todo` placeholders for results
- `report/references.bib` — 8 references cited in the report

### Project Infrastructure (Complete)
- `README.md` — Full reproduction guide
- `requirements.txt` — Pinned dependencies
- `presentation/slides_outline.md` — 8-slide structure with timing

### Scripts (Complete)
- `scripts/generate_machine_text.py` — Initial generation script
- `scripts/generate_machine_text_resume.py` — Resumable version
- `scripts/clean_human_text.py` — Cleans and chunks raw isiZulu text

---

## 3. What's Left ❌

### Run Experiments on Colab (Critical — do first)
| Task | Notebook | Time |
|------|----------|------|
| Run AfroXLMR (4 experiments) | `notebooks/AfroXLMR_Colab.ipynb` | ~80 min |
| Run XLM-R (4 experiments) | `notebooks/XLMR_Colab.ipynb` | ~80 min |

**How:** Upload 9 CSVs from `data/splits/`, set EXPERIMENT, run cells. See QUICKSTART in notebook headers.

### Run LIME Analysis
| Task | Notebook | Time |
|------|----------|------|
| Run LIME on best models | `notebooks/LIME_Analysis.ipynb` | ~30 min |

**Requires:** Saved model checkpoints from training (best_model folders)

### Fill In Report
- Replace all `#todo` placeholders in `report/main.typ` with actual results
- Add LIME figure
- Compile: `typst compile report/main.typ`
- Rename output to `Group57_uXXXXXXXX.pdf`

### Presentation
- Build slide deck from `presentation/slides_outline.md`
- Record ≤5 min video (due 15 June)
- Prepare for live Q&A (17 June)

---

## 4. File Structure

```
cos760-group57/
├── README.md                        # Setup + reproduction instructions
├── requirements.txt                 # Python dependencies
├── HANDOVER.md                      # This document
├── data/
│   ├── raw/                         # Original source texts
│   │   ├── zul.csv                  # Raw isiZulu (Vukuzenzele/Wikipedia)
│   │   ├── eng.csv                  # Raw English
│   │   └── zul_cues.json            # 185 topic cues for generation
│   ├── processed/                   # Cleaned and generated text
│   │   ├── human_zul_cleaned.csv
│   │   ├── human_eng_cleaned.csv
│   │   └── machine_generated_gemini.csv
│   └── splits/                      # Train/Val/Test (70/15/15)
│       ├── combined_train/val/test.csv
│       ├── eng_train/val/test.csv
│       └── zul_train/val/test.csv
├── scripts/                         # Data pipeline
│   ├── clean_human_text.py
│   ├── generate_machine_text.py
│   └── generate_machine_text_resume.py
├── notebooks/                       # Google Colab notebooks
│   ├── AfroXLMR_Colab.ipynb         # Primary model
│   ├── XLMR_Colab.ipynb             # Baseline model
│   └── LIME_Analysis.ipynb          # Explainability
├── results/                         # Experiment outputs (fill after running)
│   └── lime/                        # LIME visualisations
├── report/                          # Final report
│   ├── main.typ                     # Typst source (ACL format)
│   └── references.bib               # Bibliography
└── presentation/                    # Slide deck
    └── slides_outline.md            # Structure + timing
```

---

## 5. Marking Breakdown

| Component | Weight | Notes |
|-----------|--------|-------|
| Problem Statement | 5% | RQs clear and connected |
| Introduction | 5% | Motivate, background, guide reader |
| Literature Survey | 10% | Merits, gaps, our contribution |
| Methodology/Data | 10% | Must answer ALL RQs |
| Experiments & Results | 10% | Tied to methodology |
| Conclusion & Discussion | 10% | Close the loop, future work |
| Writing & References | 10% | ACL format, no errors |
| Presentation & Q&A | 30% | **Biggest chunk** — be prepared |
| Project Repo | 10% | README, structure, reproducible |

**Final Mark = 0.7 × (0.1×Proposal + 0.9×Final) + 0.3 × Peer Evaluation**

---

## 6. Remaining Schedule

| Day | Task |
|-----|------|
| 22 May (Today) | Run AfroXLMR + XLM-R experiments on Colab |
| 23 May | Run LIME analysis, start filling in report |
| 24 May | Complete results section, write discussion |
| 25 May | Polish report, abstract, references |
| 26 May | Final review, compile PDF, clean repo |
| 27 May | **Submit report + code zip** |
| 15 June | Record and submit video |
| 17 June | Live presentation |

---

## 7. Key Commands

```bash
# Clone the repo
git clone git@github-personal:ReeceSchmidt/cos760-group57.git

# Install Typst (Windows)
winget install typst

# Compile report
cd report
typst compile main.typ

# Rename for submission
mv main.pdf Group57_uXXXXXXXX.pdf
```

---

## 8. Key Dependencies

```
transformers, torch, datasets, scikit-learn, lime, pandas, numpy, matplotlib, scipy, accelerate
```

**Model checkpoints:**
- `Davlan/afro-xlmr-base` (AfroXLMR)
- `xlm-roberta-base` (XLM-R baseline)

---

## 9. Notes & Decisions Made

- Used **Gemma 4** (gemma-4-26b-a4b-it) instead of GPT-3.5/4 as proposed — free via Google AI API
- Human isiZulu text chunked into 4-sentence segments (≥30 words) for comparable length to machine text
- 4 prompt templates per cue to add stylistic variety to machine text
- 70/15/15 train/val/test split as per proposal
- Report written in **Typst** (tracl package) instead of LaTeX — produces identical ACL-format PDF
- Training notebooks designed for Google Colab T4 GPU (free tier)
