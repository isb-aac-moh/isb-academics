import { useState } from "react";
import { Slider, Stat, VizFrame } from "./util";

interface Props {
  cards?: number;
}

/**
 * The rule of the card, made physical: total cards is fixed, and every card is either attached to a
 * unit sitting in the buffer or travelling back as a pull signal — buffer + cardsOut always equals
 * the card count. "Produce" is disabled with no card outstanding, which is the whole mechanism: WIP
 * literally cannot exceed the number of cards in circulation, no matter how fast the customer pulls.
 */
export function KanbanLoop({ cards = 3 }: Props) {
  const [cap, setCap] = useState(cards);
  const [buffer, setBuffer] = useState(cards);
  const [cardsOut, setCardsOut] = useState(0);
  const [delivered, setDelivered] = useState(0);

  function reset(newCap = cap) {
    setBuffer(newCap);
    setCardsOut(0);
    setDelivered(0);
  }

  function pull() {
    if (buffer <= 0) return;
    setBuffer((b) => b - 1);
    setCardsOut((c) => c + 1);
    setDelivered((d) => d + 1);
  }

  function produce() {
    if (cardsOut <= 0) return;
    setCardsOut((c) => c - 1);
    setBuffer((b) => b + 1);
  }

  return (
    <VizFrame
      title="No card, no production"
      caption="Every card is either on a unit in the buffer or travelling back as a pull signal — the two always add up to the card count. Pull units as fast as you like: WIP never exceeds the card count, because Produce is blocked until a card actually comes back."
      onReset={() => reset()}
      controls={
        <Slider
          label="Kanban cards in the loop (WIP cap)"
          value={cap}
          min={1}
          max={8}
          onChange={(v) => {
            setCap(v);
            reset(v);
          }}
        />
      }
    >
      <div className="flex items-center justify-center gap-2 flex-wrap py-2">
        {Array.from({ length: cap }).map((_, i) => (
          <div
            key={i}
            className={`w-9 h-9 rounded-lg border-2 flex items-center justify-center text-[10px] font-bold transition-colors
              ${i < buffer ? "bg-accent/15 border-accent text-accent" : "bg-surface-2 border-line text-ink-soft/40"}`}
            title={i < buffer ? "Unit in buffer" : "Card travelling back"}
          >
            {i < buffer ? "●" : "↩"}
          </div>
        ))}
      </div>

      <div className="flex gap-2 justify-center mb-1">
        <button
          onClick={pull}
          disabled={buffer <= 0}
          className="btn btn-primary py-2 px-3 text-sm disabled:opacity-35 disabled:cursor-not-allowed"
        >
          Customer pulls 1 unit
        </button>
        <button
          onClick={produce}
          disabled={cardsOut <= 0}
          className="btn btn-ghost border border-line py-2 px-3 text-sm disabled:opacity-35 disabled:cursor-not-allowed"
        >
          Station produces 1 (fulfil a card)
        </button>
      </div>

      <div className="grid gap-2 sm:grid-cols-3 mt-3">
        <Stat label="WIP in buffer" value={String(buffer)} tone="accent" hint={`Capped at ${cap}, no matter what`} />
        <Stat label="Cards awaiting production" value={String(cardsOut)}
          tone={cardsOut > 0 ? "bad" : "good"} hint="Produce is blocked until this is > 0" />
        <Stat label="Delivered to customer" value={String(delivered)} hint="Running total this session" />
      </div>
    </VizFrame>
  );
}
