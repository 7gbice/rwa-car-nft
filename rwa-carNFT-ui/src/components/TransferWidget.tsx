import React, { useState } from "react";

type TransferWidgetProps = {
  onTransfer: (details: {
    chainSelector: string;
    tokenId: string;
    receiver: string;
  }) => void;
};

const TransferWidget: React.FC<TransferWidgetProps> = ({ onTransfer }) => {
  const [chainSelector, setChainSelector] = useState("");
  const [tokenId, setTokenId] = useState("");
  const [receiver, setReceiver] = useState("");

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onTransfer({ chainSelector, tokenId, receiver });
      }}
      className="bg-white p-6 rounded-md shadow-lg space-y-4"
    >
      <h2 className="text-xl font-bold text-gray-800">🔁 Send Car Cross-Chain</h2>

      <input
        type="text"
        value={tokenId}
        onChange={(e) => setTokenId(e.target.value)}
        placeholder="Car Token ID"
        className="w-full border px-4 py-2 rounded text-sm focus:ring-2 focus:ring-purple-400"
      />

      <input
        type="text"
        value={chainSelector}
        onChange={(e) => setChainSelector(e.target.value)}
        placeholder="Destination Chain Selector"
        className="w-full border px-4 py-2 rounded text-sm focus:ring-2 focus:ring-purple-400"
      />

      <input
        type="text"
        value={receiver}
        onChange={(e) => setReceiver(e.target.value)}
        placeholder="Receiver Address"
        className="w-full border px-4 py-2 rounded text-sm focus:ring-2 focus:ring-purple-400"
      />

      <button
        type="submit"
        className="bg-green-600 text-white py-2 px-4 rounded hover:bg-green-700"
      >
        Transfer NFT
      </button>
    </form>
  );
};

export default TransferWidget;
