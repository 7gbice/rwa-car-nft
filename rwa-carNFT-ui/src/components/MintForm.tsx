import React, { useState } from "react";

type CarMintFormProps = {
  onSubmit: (form: {
    vin: string;
    mileage: string;
    engine: string;
    color: string;
    image: string;
  }) => void;
};

const MintForm: React.FC<CarMintFormProps> = ({ onSubmit }) => {
  const [form, setForm] = useState({
    vin: "",
    mileage: "",
    engine: "",
    color: "",
    image: ""
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onSubmit(form);
      }}
      className="bg-white p-6 rounded-md shadow-lg space-y-4"
    >
      <h2 className="text-xl font-bold text-gray-800">🚙 Mint New Car NFT</h2>

      {["vin", "mileage", "engine", "color", "image"].map((field) => (
        <input
          key={field}
          name={field}
          value={(form as any)[field]}
          onChange={handleChange}
          placeholder={field.charAt(0).toUpperCase() + field.slice(1)}
          className="w-full border px-4 py-2 rounded text-sm focus:ring-2 focus:ring-blue-400"
        />
      ))}

      <button
        type="submit"
        className="bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700"
      >
        Mint NFT
      </button>
    </form>
  );
};

export default MintForm;
