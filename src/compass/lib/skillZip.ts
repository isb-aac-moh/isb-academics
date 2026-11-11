// Builds a zip holding one text file, uncompressed. Claude's skill upload wants a zip with the skill
// folder inside (compass/SKILL.md), and building it here keeps the download in step with skills/compass.
const CRC = Array.from({ length: 256 }, (_, n) => { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1; return c >>> 0; });
const crc32 = (b: Uint8Array) => { let c = ~0; for (const x of b) c = CRC[(c ^ x) & 255] ^ (c >>> 8); return ~c >>> 0; };
const u16 = (n: number) => [n & 255, (n >> 8) & 255];
const u32 = (n: number) => [n & 255, (n >> 8) & 255, (n >> 16) & 255, (n >>> 24) & 255];

export function zipOne(path: string, text: string): Blob {
  const enc = new TextEncoder(), name = enc.encode(path), data = enc.encode(text), crc = crc32(data), size = data.length;
  const DATE = 33; // 1 Jan 1980, the earliest date a zip can hold
  const local = [...u32(0x04034b50), ...u16(20), ...u16(0x800), ...u16(0), ...u16(0), ...u16(DATE), ...u32(crc), ...u32(size), ...u32(size), ...u16(name.length), ...u16(0)];
  const central = [...u32(0x02014b50), ...u16(20), ...u16(20), ...u16(0x800), ...u16(0), ...u16(0), ...u16(DATE), ...u32(crc), ...u32(size), ...u32(size), ...u16(name.length), ...u16(0), ...u16(0), ...u16(0), ...u16(0), ...u32(0), ...u32(0)];
  const end = [...u32(0x06054b50), ...u16(0), ...u16(0), ...u16(1), ...u16(1), ...u32(central.length + name.length), ...u32(local.length + name.length + size), ...u16(0)];
  return new Blob([new Uint8Array(local), name, data, new Uint8Array(central), name, new Uint8Array(end)], { type: "application/zip" });
}
