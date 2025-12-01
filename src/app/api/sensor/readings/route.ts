import { NextRequest, NextResponse } from 'next/server';
import pool from '@/lib/db';

export async function POST(request: NextRequest) {
  try {
    const { temperature, co2, particulate, air_quality_status, fan_status } =
      await request.json();

    // Validate input
    if (
      temperature === undefined ||
      co2 === undefined ||
      particulate === undefined ||
      !air_quality_status
    ) {
      return NextResponse.json(
        { error: 'Data sensor tidak lengkap' },
        { status: 400 }
      );
    }

    // Insert into database
    const result = await pool.query(
      'INSERT INTO sensor_readings (temperature, co2, particulate, air_quality_status, fan_status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [temperature, co2, particulate, air_quality_status, fan_status]
    );

    return NextResponse.json(
      {
        success: true,
        data: result.rows[0],
      },
      { status: 201 }
    );
  } catch (error) {
    console.error('Sensor data error:', error);
    return NextResponse.json(
      { error: 'Gagal menyimpan data sensor' },
      { status: 500 }
    );
  }
}

export async function GET(request: NextRequest) {
  try {
    // Get latest sensor readings (last 100)
    const result = await pool.query(
      'SELECT * FROM sensor_readings ORDER BY created_at DESC LIMIT 100'
    );

    return NextResponse.json({
      success: true,
      data: result.rows,
    });
  } catch (error) {
    console.error('Get sensor data error:', error);
    return NextResponse.json(
      { error: 'Gagal mengambil data sensor' },
      { status: 500 }
    );
  }
}
