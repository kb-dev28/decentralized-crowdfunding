import Link from "next/link";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-8 p-8">
      <div className="max-w-lg text-center">
        <h1 className="text-3xl font-bold tracking-tight">
          Decentralized Crowdfunding
        </h1>
        <p className="mt-3 text-muted-foreground text-zinc-600 dark:text-zinc-400">
          Launch campaigns, donate with ETH, and track progress on-chain.
          Web3 integration comes in Etapa 2.
        </p>
      </div>
      <nav className="flex flex-col gap-3 sm:flex-row">
        <Link
          href="/campaigns"
          className="rounded-lg bg-zinc-900 px-6 py-3 text-sm font-medium text-white hover:bg-zinc-800 dark:bg-zinc-100 dark:text-zinc-900 dark:hover:bg-zinc-200"
        >
          Browse campaigns
        </Link>
        <Link
          href="/create"
          className="rounded-lg border border-zinc-300 px-6 py-3 text-sm font-medium hover:bg-zinc-50 dark:border-zinc-700 dark:hover:bg-zinc-900"
        >
          Create campaign
        </Link>
      </nav>
    </div>
  );
}
