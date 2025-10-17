import { useState } from "react";
import Papa from "papaparse";
import * as XLSX from "xlsx";

export default function UploadDataset() {
  const [data, setData] = useState<any[]>([]);
  const [columns, setColumns] = useState<string[]>([]);

  const handleFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const fileExtension = file.name.split(".").pop()?.toLowerCase();

    if (fileExtension === "csv") {
      Papa.parse(file, {
        header: true,
        skipEmptyLines: true,
        complete: (result) => {
          setColumns(Object.keys(result.data[0]));
          setData(result.data);
        },
      });
    } else if (fileExtension === "xlsx" || fileExtension === "xls") {
      const reader = new FileReader();
      reader.onload = (e) => {
        const binaryStr = e.target?.result;
        const workbook = XLSX.read(binaryStr, { type: "binary" });
        const sheetName = workbook.SheetNames[0];
        const sheet = workbook.Sheets[sheetName];
        const jsonData = XLSX.utils.sheet_to_json(sheet);
        setColumns(Object.keys(jsonData[0]));
        setData(jsonData);
      };
      reader.readAsBinaryString(file);
    } else {
      alert("Solo se permiten archivos .csv o .xlsx");
    }
  };

  return (
    <div className="flex flex-col items-center py-10">
      <h2 className="text-2xl font-semibold mb-4">Upload your dataset</h2>

      <label className="cursor-pointer bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700 transition">
        Select File
        <input type="file" accept=".csv,.xlsx,.xls" onChange={handleFile} className="hidden" />
      </label>

      {data.length > 0 && (
        <div className="mt-8 w-full max-w-5xl overflow-x-auto">
          <table className="min-w-full border border-gray-300 bg-white rounded-lg shadow-sm">
            <thead className="bg-gray-200">
              <tr>
                {columns.map((col) => (
                  <th key={col} className="px-4 py-2 border-b text-sm font-medium text-gray-700">
                    {col}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.slice(0, 10).map((row, i) => (
                <tr key={i} className="hover:bg-gray-50">
                  {columns.map((col) => (
                    <td key={col} className="px-4 py-2 border-b text-sm text-gray-600">
                      {row[col] as string}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>

          <p className="text-gray-500 text-sm mt-3">
            Showing first 10 rows of {data.length} loaded.
          </p>
        </div>
      )}
    </div>
  );
}
