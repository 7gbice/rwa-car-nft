
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import './index.css'; // ✅ Tailwind styles included here

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

useEffect(() => {
  async function connectWallet() {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = getCarNFTContract(signer);

      // Example: fetch user's car NFTs or metadata
      const balance = await contract.balanceOf(await signer.getAddress());
      console.log("Car NFTs Owned:", balance.toString());
    }
  }

  connectWallet();
}, []);

