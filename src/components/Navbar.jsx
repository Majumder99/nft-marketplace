import fullLogo from "../full_logo.png";
import { Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { useLocation } from "react-router";
import { ethers } from "ethers";

function Navbar() {
  const [connected, setConnected] = useState(false);
  const location = useLocation();
  const [currentAddress, setCurrentAddress] = useState("");

  // async function getAddress() {
  //   const provider = new ethers.providers.Web3Provider(window.ethereum);
  //   const signer = provider.getSigner();
  //   const addr = await signer.getAddress();
  //   updateAddress(addr);
  // }
  console.log("address of contract", currentAddress);
  // function updateButton() {
  //   const ethereumButton = document.querySelector(".enableEthereumButton");
  //   ethereumButton.textContent = "Connected";
  //   ethereumButton.classList.remove("hover:bg-blue-70");
  //   ethereumButton.classList.remove("bg-blue-500");
  //   ethereumButton.classList.add("hover:bg-green-70");
  //   ethereumButton.classList.add("bg-green-500");
  // }

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        console.log("please install MetaMask");
      }

      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });

      setCurrentAddress(accounts[0]);
      setConnected(true);
    } catch (error) {
      console.log(error);
    }
  };

  // useEffect(() => {
  //   if (window.ethereum == undefined) return;
  //   let val = window.ethereum.isConnected();
  //   if (val) {
  //     console.log("here");
  //     getAddress();
  //     toggleConnect(val);
  //     updateButton();
  //   }
  //   window.ethereum.on("accountsChanged", function () {
  //     getAddress();
  //     window.location.replace(location.pathname);
  //   });
  // }, []);

  return (
    <div className="">
      <nav className="w-screen">
        <ul className="flex items-end flex-row justify-between py-3 bg-transparent text-white pr-5">
          <li className="flex items-end ml-5 pb-2">
            <Link to="/">
              <img
                src={fullLogo}
                alt=""
                width={120}
                height={120}
                className="inline-block -mt-2"
              />
              <div className="inline-block font-bold text-xl ml-2">
                NFT Marketplace
              </div>
            </Link>
          </li>
          <li className="w-2/6">
            <ul className="lg:flex justify-between font-bold mr-10 text-lg">
              {location.pathname === "/" ? (
                <li className="border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/">Marketplace</Link>
                </li>
              ) : (
                <li className="hover:border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/">Marketplace</Link>
                </li>
              )}
              {location.pathname === "/sellNFT" ? (
                <li className="border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/sellNFT">List My NFT</Link>
                </li>
              ) : (
                <li className="hover:border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/sellNFT">List My NFT</Link>
                </li>
              )}
              {location.pathname === "/profile" ? (
                <li className="border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/profile">Profile</Link>
                </li>
              ) : (
                <li className="hover:border-b-2 hover:pb-0 p-2 text-black">
                  <Link to="/profile">Profile</Link>
                </li>
              )}
              <li>
                <button
                  className="enableEthereumButton bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded text-sm"
                  onClick={connectWallet}
                >
                  {connected ? "Connected" : "Connect Wallet"}
                </button>
              </li>
            </ul>
          </li>
        </ul>
      </nav>
      <div className="text-black text-bold text-right mr-10 text-sm">
        {currentAddress !== "0x"
          ? "Connected to"
          : "Not Connected. Please login to view NFTs"}{" "}
        {currentAddress !== "0x" ? currentAddress.substring(0, 15) + "..." : ""}
      </div>
    </div>
  );
}

export default Navbar;
