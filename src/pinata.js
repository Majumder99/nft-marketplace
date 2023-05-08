//require('dotenv').config();
const key = import.meta.env.PINATA_API;
const secret = import.meta.env.PINATA_SECRET;
const pintat_jwt = import.meta.env.PINATA_JWT;

import axios from "axios";
import FormData from "form-data";

export const uploadJSONToIPFS = async (JSONBody) => {
  const url = `https://api.pinata.cloud/pinning/pinFileToIPFS`;
  //making axios POST request to Pinata ⬇️
  const res = await axios
    .post(url, {
      headers: {
        Authorization: `Bearer ${pintat_jwt}`,
      },
      JSONBody,
    })
    .then(function (response) {
      return {
        success: true,
        pinataURL:
          "https://gateway.pinata.cloud/ipfs/" + response.data.IpfsHash,
      };
    })
    .catch(function (error) {
      console.log(error);
      return {
        success: false,
        message: error.message,
      };
    });
  console.log(res);
  return res;
};

export const uploadFileToIPFS = async (file) => {
  if (file) {
    try {
      const formData = new FormData();
      formData.append("file", file);
      const resFile = await axios({
        method: "post",
        url: "https://api.pinata.cloud/pinning/pinFileToIPFS",
        data: formData,
        headers: {
          pinata_api_key: key,
          pinata_secret_api_key: secret,
          "Content-Type": "multiple/form-data",
        },
      });
      console.log("res", resFile);
    } catch (error) {
      console.log("error", error);
    }
  }
  // const url = `https://api.pinata.cloud/pinning/pinFileToIPFS`;
  // //making axios POST request to Pinata ⬇️

  // let data = new FormData();
  // let d = {};
  // await data.append("file", file);
  // d.file = file;
  // console.log("File name :,", file.name);

  // const metadata = JSON.stringify({
  //   name: `${file.name}`,
  // });
  // await data.append("pinataMetadata", metadata);
  // d.pinataMetadata = metadata;
  // //pinataOptions are optional
  // const pinataOptions = JSON.stringify({
  //   cidVersion: 0,
  //   customPinPolicy: {
  //     regions: [
  //       {
  //         id: "FRA1",
  //         desiredReplicationCount: 1,
  //       },
  //       {
  //         id: "NYC1",
  //         desiredReplicationCount: 2,
  //       },
  //     ],
  //   },
  // });
  // await data.append("pinataOptions", pinataOptions);
  // d.pinataOptions = pinataOptions;
  // data.append("sourav", 5);
  // console.log("data of image", d);
  // const res = await axios.post(url, {
  //   maxBodyLength: "Infinity",
  //   headers: {
  //     "Content-Type": `multipart/form-data; boundary=${data._boundary}`,
  //     Authorization: `Bearer ${pintat_jwt}`,
  //   },
  //   d,
  // });
  // console.log("res", res);

  // .then(function (response) {
  //   console.log("image uploaded", response.data.IpfsHash);
  //   return {
  //     success: true,
  //     pinataURL:
  //       "https://gateway.pinata.cloud/ipfs/" + response.data.IpfsHash,
  //   };
  // })
  // .catch(function (error) {
  //   console.log(error);
  //   return {
  //     success: false,
  //     message: error.message,
  //   };
  // });
  // return res;
};
