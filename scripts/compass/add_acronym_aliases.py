"""Add acronym <-> full-name aliases to cards, so "NPV" finds "net present value" and the reverse.

Search matches words, so a card titled "MM Proposition I" is invisible to "Modigliani Miller". Cards are rebuilt
by card_pilot.py export, which drops edits made to the live file, so re-run this after every export:

    python3 scripts/compass/add_acronym_aliases.py in.json out.json

Safe to re-run: an alias is added only when the card's title and aliases don't already contain it.
"""
import json, re, sys

PAIRS = {
    "ESG": "environmental social and governance", "ML": "machine learning", "AUC": "area under the curve",
    "WACC": "weighted average cost of capital", "CSR": "corporate social responsibility",
    "LTV": "customer lifetime value", "RAG": "retrieval augmented generation", "MVP": "minimum viable product",
    "UMAP": "uniform manifold approximation and projection", "SNE": "stochastic neighbour embedding",
    "NPV": "net present value", "IRR": "internal rate of return", "BRSR": "business responsibility and sustainability report",
    "UX": "user experience", "CAC": "customer acquisition cost", "BCG": "Boston Consulting Group growth share matrix",
    "VRIN": "valuable rare inimitable non-substitutable", "RICE": "reach impact confidence effort",
    "ICE": "impact confidence ease", "LLM": "large language model", "DPDP": "Digital Personal Data Protection Act",
    "RLHF": "reinforcement learning from human feedback", "TF-IDF": "term frequency inverse document frequency",
    "PMF": "product market fit", "OEM": "original equipment manufacturer", "OCI": "other comprehensive income",
    "R&D": "research and development", "APV": "adjusted present value", "APIC": "additional paid-in capital",
    "CAPM": "capital asset pricing model", "EPS": "earnings per share", "IFRS": "International Financial Reporting Standards",
    "Ind AS": "Indian Accounting Standards", "IID": "independent and identically distributed", "OLS": "ordinary least squares",
    "DBI": "Davies-Bouldin index", "ROC": "receiver operating characteristic", "POC": "proof of concept",
    "SOTA": "state of the art", "M&A": "mergers and acquisitions", "PRD": "product requirements document",
    "TAM": "total addressable market", "SAM": "serviceable available market", "SOM": "serviceable obtainable market",
    "VC": "venture capital", "EOQ": "economic order quantity", "ZMET": "Zaltman metaphor elicitation technique",
    "PM": "product management", "CAGE": "cultural administrative geographic economic distance",
    "MR = MC": "marginal revenue equals marginal cost",
}
# The MM cards say "MM" and a proposition number; the founders' names are what people type.
MM = {"mm-proposition-i": "Modigliani Miller Proposition I", "mm-proposition-ii": "Modigliani Miller Proposition II",
      "mm-proposition-i-with-taxes": "Modigliani Miller Proposition I with taxes"}

norm = lambda s: re.sub(r"[^a-z0-9&]+", " ", s.lower()).strip()
has = lambda text, term: re.search(r"(?<![a-z0-9])" + re.escape(norm(term)) + r"(?![a-z0-9])", norm(text)) is not None

def main(src, dst):
    data = json.load(open(src))
    added = 0
    for c in data["cards"]:
        seen = c["title"] + " | " + " | ".join(c["aliases"])
        want = [MM[c["id"].split(":")[-1]]] if c["id"].split(":")[-1] in MM else []
        for short, full in PAIRS.items():
            if has(c["title"], short) and not has(seen, full): want.append(full)
            elif has(c["title"], full) and not has(seen, short): want.append(short)
        want = [w for w in dict.fromkeys(want) if not has(seen, w)]
        c["aliases"] += want
        added += len(want)
    json.dump(data, open(dst, "w"), ensure_ascii=False, separators=(",", ":"))
    print(f"{added} aliases added across {len(data['cards'])} cards")

if __name__ == "__main__":
    main(*sys.argv[1:3])
