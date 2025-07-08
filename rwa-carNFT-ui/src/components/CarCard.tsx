import React from "react";

type CarCardProps = {
  vin: string;
  mileage: string;
  engine: string;
  color: string;
  image: string;
  value: string;
};

const CarCard: React.FC<CarCardProps> = ({
  vin,
  mileage,
  engine,
  color,
  image,
  value
}) => {
  return (
    <div className="bg-white shadow-md rounded-lg p-4 border border-gray-200 hover:scale-[1.01] transition-transform">
      <img
        src={image}
        alt={`Car ${vin}`}
        className="w-full h-40 object-cover rounded-md mb-4"
      />
      <h3 className="text-lg font-bold mb-2 text-gray-800">{vin}</h3>
      <ul className="text-sm text-gray-600 space-y-1">
        <li><span className="font-semibold">Engine:</span> {engine}</li>
        <li><span className="font-semibold">Mileage:</span> {mileage} km</li>
        <li><span className="font-semibold">Color:</span> {color}</li>
        <li><span className="font-semibold">Value:</span> ${value}</li>
      </ul>
    </div>
  );
};

export default CarCard;
