"use client"

import { useState, useEffect } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { ChartContainer, ChartTooltip, ChartTooltipContent } from "@/components/ui/chart"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, ResponsiveContainer } from "recharts"
import { createClient } from "@/lib/supabase/client"

interface ChartData {
  category_name: string
  quantity: number
}

export function Dashboard() {
  const [chartData, setChartData] = useState<ChartData[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    async function fetchData() {
      setLoading(true)
      const { data, error } = await supabase.rpc("get_dashboard_stats")

      if (error) {
        console.error("Error fetching dashboard stats:", error)
        setChartData([])
      } else if (data) {
        setChartData(data.category_distribution || [])
      }
      setLoading(false)
    }

    fetchData()
  }, [])

  return (
    <Card>
      <CardHeader>
        <CardTitle>Inventory by Category</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="h-[400px] w-full">
          {loading ? (
            <div className="flex items-center justify-center h-full text-slate-500">Loading chart data...</div>
          ) : chartData.length > 0 ? (
            <ChartContainer
              config={{
                quantity: {
                  label: "Quantity",
                  color: "hsl(var(--chart-1))",
                },
              }}
            >
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={chartData} margin={{ top: 20, right: 20, bottom: 5, left: 20 }}>
                  <CartesianGrid vertical={false} strokeDasharray="3 3" />
                  <XAxis dataKey="category_name" tick={{ fontSize: 12 }} angle={-45} textAnchor="end" height={60} />
                  <YAxis allowDecimals={false} />
                  <ChartTooltip cursor={false} content={<ChartTooltipContent indicator="dot" />} />
                  <Bar dataKey="quantity" fill="var(--color-quantity)" radius={4} />
                </BarChart>
              </ResponsiveContainer>
            </ChartContainer>
          ) : (
            <div className="flex items-center justify-center h-full text-slate-500">No data available.</div>
          )}
        </div>
      </CardContent>
    </Card>
  )
}
