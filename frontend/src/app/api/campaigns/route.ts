import { NextResponse } from "next/server";

/** Off-chain campaign metadata (images, descriptions) — MongoDB in a later phase. */
export async function GET() {
  return NextResponse.json(
    { message: "Campaigns API — not implemented yet" },
    { status: 501 },
  );
}
