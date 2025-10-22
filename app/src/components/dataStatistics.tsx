import { useMemo } from "react";

interface DataStatisticsProps {
  data: any[];
  columns: string[];
}

export default function DataStatistics({ data, columns }: DataStatisticsProps) {
  const statistics = useMemo(() => {
    if (data.length === 0 || columns.length === 0) return null;

    const stats: { [key: string]: any } = {};

    columns.forEach((col) => {
      const values = data.map((row) => row[col]).filter((v) => v !== null && v !== undefined && v !== "");
      const numericValues = values.filter((v) => !isNaN(Number(v))).map(Number);

      stats[col] = {
        count: values.length,
        missing: data.length - values.length,
        unique: new Set(values).size,
        type: numericValues.length > values.length * 0.8 ? "numeric" : "categorical",
      };

      if (stats[col].type === "numeric" && numericValues.length > 0) {
        const sorted = [...numericValues].sort((a, b) => a - b);
        const sum = numericValues.reduce((acc, val) => acc + val, 0);
        const mean = sum / numericValues.length;
        
        stats[col].min = Math.min(...numericValues);
        stats[col].max = Math.max(...numericValues);
        stats[col].mean = parseFloat(mean.toFixed(2));
        stats[col].median = sorted[Math.floor(sorted.length / 2)];
        
        const variance = numericValues.reduce((acc, val) => acc + Math.pow(val - mean, 2), 0) / numericValues.length;
        stats[col].std = parseFloat(Math.sqrt(variance).toFixed(2));
      } else {
        const frequency: { [key: string]: number } = {};
        values.forEach((v) => {
          const key = String(v);
          frequency[key] = (frequency[key] || 0) + 1;
        });
        const sortedFreq = Object.entries(frequency).sort((a, b) => b[1] - a[1]);
        stats[col].mostCommon = sortedFreq[0]?.[0] || "N/A";
        stats[col].frequency = sortedFreq[0]?.[1] || 0;
      }
    });

    return stats;
  }, [data, columns]);

  if (!statistics) return null;

  return (
    <div className="mt-8 w-full max-w-6xl">
      <h3 className="text-2xl font-semibold mb-4 text-gray-800">Dataset Statistics</h3>
      
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-blue-50 p-4 rounded-lg">
            <p className="text-sm text-gray-600">Total Rows</p>
            <p className="text-3xl font-bold text-blue-600">{data.length}</p>
          </div>
          <div className="bg-green-50 p-4 rounded-lg">
            <p className="text-sm text-gray-600">Total Columns</p>
            <p className="text-3xl font-bold text-green-600">{columns.length}</p>
          </div>
          <div className="bg-purple-50 p-4 rounded-lg">
            <p className="text-sm text-gray-600">Numeric Columns</p>
            <p className="text-3xl font-bold text-purple-600">
              {Object.values(statistics).filter((s: any) => s.type === "numeric").length}
            </p>
          </div>
        </div>
      </div>

      <div className="overflow-x-auto">
        <table className="min-w-full border border-gray-300 bg-white rounded-lg shadow-sm">
          <thead className="bg-gray-200">
            <tr>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-left">Column</th>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-center">Type</th>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-center">Count</th>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-center">Missing</th>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-center">Unique</th>
              <th className="px-4 py-3 border-b text-sm font-semibold text-gray-700 text-center">Stats</th>
            </tr>
          </thead>
          <tbody>
            {columns.map((col) => {
              const stat = statistics[col];
              return (
                <tr key={col} className="hover:bg-gray-50">
                  <td className="px-4 py-3 border-b text-sm font-medium text-gray-800">{col}</td>
                  <td className="px-4 py-3 border-b text-sm text-center">
                    <span
                      className={`px-2 py-1 rounded-full text-xs font-semibold ${
                        stat.type === "numeric"
                          ? "bg-blue-100 text-blue-800"
                          : "bg-orange-100 text-orange-800"
                      }`}
                    >
                      {stat.type}
                    </span>
                  </td>
                  <td className="px-4 py-3 border-b text-sm text-gray-600 text-center">{stat.count}</td>
                  <td className="px-4 py-3 border-b text-sm text-center">
                    <span
                      className={`${
                        stat.missing > 0 ? "text-red-600 font-semibold" : "text-gray-600"
                      }`}
                    >
                      {stat.missing}
                    </span>
                  </td>
                  <td className="px-4 py-3 border-b text-sm text-gray-600 text-center">{stat.unique}</td>
                  <td className="px-4 py-3 border-b text-sm text-gray-600">
                    {stat.type === "numeric" ? (
                      <div className="text-xs space-y-1">
                        <div className="flex justify-between">
                          <span className="text-gray-500">Mean:</span>
                          <span className="font-medium">{stat.mean}</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-500">Min/Max:</span>
                          <span className="font-medium">{stat.min} / {stat.max}</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-500">Std Dev:</span>
                          <span className="font-medium">{stat.std}</span>
                        </div>
                      </div>
                    ) : (
                      <div className="text-xs">
                        <div className="flex justify-between">
                          <span className="text-gray-500">Most common:</span>
                          <span className="font-medium truncate max-w-[100px]" title={stat.mostCommon}>
                            {stat.mostCommon}
                          </span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-gray-500">Frequency:</span>
                          <span className="font-medium">{stat.frequency}</span>
                        </div>
                      </div>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
