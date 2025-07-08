import React from "react";

type Props = {
  address: string | null;
};

const WalletBar: React.FC<Props> = ({ address }) => {
  return (
    <div className="bg-gray-900 text-white py-4 px-6 flex justify-between items-center rounded-b-md">
      <h1 className="text-lg font-semibold">🔗 Connected Dashboard</h1>
      <span className="text-sm font-mono">
        {address ? `Wallet: ${address.slice(0, 6)}...${address.slice(-4)}` : "Connecting..."}
      </span>
    </div>
  );
};

export default WalletBar;
