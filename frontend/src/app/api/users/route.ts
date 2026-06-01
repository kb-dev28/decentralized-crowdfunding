import { NextResponse } from "next/server";

/** User profiles — optional off-chain storage. */
export async function GET() {
  return NextResponse.json(
    { message: "Users API — not implemented yet" },
    { status: 501 },
  );
}
