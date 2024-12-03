import { useState, useEffect } from "react";
import { ethers } from "ethers";
import assessmentABI from "../artifacts/contracts/Assessment.sol/Assessment.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [assessment, setAssessment] = useState(undefined);
  const [value, setValue] = useState(undefined);

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const assessment_ABI = assessmentABI.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const account = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(account);
    }
  };

  const handleAccount = (account) => {
    if (account) {
      console.log("Account connected: ", account);
      setAccount(account);
    } else {
      console.log("No account found");
    }
  };

  const connectAccount = async () => {
    if (!ethWallet) {
      alert("MetaMask wallet is required to connect");
      return;
    }

    const accounts = await ethWallet.request({ method: "eth_requestAccounts" });
    handleAccount(accounts);

    getAssessment();
  };

  const getAssessment = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const assessment = new ethers.Contract(contractAddress, assessment_ABI, signer);

    setAssessment(assessment);
  };

  const fetchValue = async () => {
    if (assessment) {
      setValue((await assessment.getValue()).toNumber());
    }
  };

  const updateValue = async (newValue) => {
    if (assessment) {
      let tx = await assessment.setValue(newValue);
      await tx.wait();
      fetchValue();
    }
  };

  const incrementValue = async () => {
    if (assessment) {
      let tx = await assessment.incrementValue();
      await tx.wait();
      fetchValue();
    }
  };

  const initUser = () => {
    if (!ethWallet) {
      return <p>Please install MetaMask to use this application.</p>;
    }

    if (!account) {
      return <button onClick={connectAccount}>Connect MetaMask Wallet</button>;
    }

    if (value === undefined) {
      fetchValue();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Current Value: {value}</p>
        <button onClick={() => updateValue(1)}>Set Value to 1</button>
        <button onClick={incrementValue}>Increment Value</button>
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main className="container">
      <header><h1>Simple Contract Interaction</h1></header>
      {initUser()}
      <style jsx>{`
        .container {
          text-align: center;
        }
      `}</style>
    </main>
  );
}
