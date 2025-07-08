import { useEffect, useState } from "react";
import { ethers } from "ethers";

export default function useWallet() {
  const [address, setAddress] = useState<string | null>(null);
  const [provider, setProvider] = useState<ethers.providers.Web3Provider | null>(null);
  const [signer, setSigner] = useState<ethers.Signer | null>(null);

  useEffect(() => {
    async function connect() {
      if (window.ethereum) {
        const _provider = new ethers.providers.Web3Provider(window.ethereum);
        await _provider.send("eth_requestAccounts", []);
        const _signer = _provider.getSigner();
        const _address = await _signer.getAddress();

        setProvider(_provider);
        setSigner(_signer);
        setAddress(_address);
      }
    }

    connect();
  }, []);

  return { address, provider, signer };
}
