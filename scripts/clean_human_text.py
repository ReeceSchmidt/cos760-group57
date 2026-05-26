import pandas as pd
import re

df = pd.read_csv('/mnt/c/users/reece/cos/760/groupwork/zul.csv')

samples = []

for _, row in df.iterrows():
    text = str(row['text'])
    # Remove literal \n
    text = text.replace('\n', ' ')
    # Fix hyphenated line breaks (e.g. 'ukuhli- nzeka' -> 'ukuhlinzeka')
    text = re.sub(r'(\w)- (\w)', r'\1\2', text)
    # Remove multiple spaces
    text = re.sub(r'\s+', ' ', text).strip()

    # Split into sentences
    sentences = re.split(r'(?<=[.!?])\s+', text)

    # Group into chunks of 4 sentences
    chunk_size = 4
    for i in range(0, len(sentences), chunk_size):
        chunk = ' '.join(sentences[i:i+chunk_size]).strip()
        word_count = len(chunk.split())
        if word_count >= 30:
            samples.append({
                'text': chunk,
                'language': 'zul',
                'source': 'human',
                'model': 'none',
                'topic': row['title'].strip() if pd.notna(row['title']) else ''
            })

result = pd.DataFrame(samples)
print(f'Total clean human isiZulu samples: {len(result)}')
print(f'\nWord count stats:')
print(result['text'].apply(lambda x: len(x.split())).describe())
print(f'\nSample (first):')
print(result.iloc[0]['text'][:400])
print(f'\nSample (middle):')
print(result.iloc[500]['text'][:400])

result.to_csv('/mnt/c/users/reece/cos/760/groupwork/human_zul_cleaned.csv', index=False)
print(f'\nSaved to human_zul_cleaned.csv')
