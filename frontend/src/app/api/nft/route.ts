import { NextResponse } from "next/server";

/** Pinata / NFT uploads — when DonorNFT.sol is added. */
export async function GET() {
  return NextResponse.json(
    { message: "NFT API — not implemented yet" },
    { status: 501 },
  );
}
