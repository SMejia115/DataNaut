import { useMemo } from "react";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";

interface DataVisualizationProps {
  data: any[];
  columns: string[];
}

const COLORS = ["#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6", "#ec4899", "#14b8a6", "#f97316"];

export default function DataVisualization({ data, columns }: DataVisualizationProps) {
  const charts = useMemo(() => {
    if (data.length === 0 || columns.length === 0) return [];

    const visualizations: any[] = [];

    columns.forEach((col, index) => {
      const values = data.map((row) => row[col]).filter((v) => v !== null && v !== undefined && v !== "");
      const numericValues = values.filter((v) => !isNaN(Number(v))).map(Number);
      const isNumeric = numericValues.length > values.length * 0.8;

      if (isNumeric && numericValues.length > 0) {
        // Create histogram for numeric data
        const bins = 10;
        const min = Math.min(...numericValues);
        const max = Math.max(...numericValues);
        const binSize = (max - min) / bins;
        
        const histogram = Array(bins).fill(0).map((_, i) => ({
          range: `${(min + i * binSize).toFixed(1)}-${(min + (i + 1) * binSize).toFixed(1)}`,
          count: 0,
        }));

        numericValues.forEach((val) => {
          const binIndex = Math.min(Math.floor((val - min) / binSize), bins - 1);
          histogram[binIndex].count++;
        });

        visualizations.push({
          type: "bar",
          title: `${col} Distribution`,
          data: histogram,
          dataKey: "count",
          xKey: "range",
          color: COLORS[index % COLORS.length],
        });
      } else {
        // Create pie chart for categorical data (top 8 values)
        const frequency: { [key: string]: number } = {};
        values.forEach((v) => {
          const key = String(v);
          frequency[key] = (frequency[key] || 0) + 1;
        });

        const pieData = Object.entries(frequency)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 8)
          .map(([name, value]) => ({ name, value }));

        visualizations.push({
          type: "pie",
          title: `${col} Distribution`,
          data: pieData,
        });
      }
    });

    return visualizations;
  }, [data, columns]);

  if (charts.length === 0) {
    return (
      <div className="mt-8 w-full max-w-6xl text-center">
        <p className="text-gray-500">No data available for visualization</p>
      </div>
    );
  }

  return (
    <div className="mt-8 w-full max-w-6xl">
      <h3 className="text-2xl font-semibold mb-6 text-gray-800">Data Visualizations</h3>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {charts.map((chart, index) => (
          <div key={index} className="bg-white rounded-lg shadow-md p-6">
            <h4 className="text-lg font-semibold mb-4 text-gray-700">{chart.title}</h4>
            
            <ResponsiveContainer width="100%" height={300}>
              {chart.type === "bar" ? (
                <BarChart data={chart.data}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey={chart.xKey} angle={-45} textAnchor="end" height={80} fontSize={12} />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey={chart.dataKey} fill={chart.color} name="Count" />
                </BarChart>
              ) : (
                <PieChart>
                  <Pie
                    data={chart.data}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                    outerRadius={100}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {chart.data.map((_: any, i: number) => (
                      <Cell key={`cell-${i}`} fill={COLORS[i % COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              )}
            </ResponsiveContainer>
          </div>
        ))}
      </div>
    </div>
  );
}
