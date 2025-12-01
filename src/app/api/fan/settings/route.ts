import { NextRequest, NextResponse } from 'next/server';
import pool from '@/lib/db';

export async function GET(request: NextRequest) {
  try {
    const result = await pool.query(
      'SELECT * FROM fan_settings LIMIT 1'
    );

    if (result.rows.length === 0) {
      // Create default settings if not exist
      await pool.query(
        'INSERT INTO fan_settings (is_auto_mode) VALUES (TRUE)'
      );
      const newResult = await pool.query(
        'SELECT * FROM fan_settings LIMIT 1'
      );
      return NextResponse.json(newResult.rows[0]);
    }

    return NextResponse.json(result.rows[0]);
  } catch (error) {
    console.error('Get fan settings error:', error);
    return NextResponse.json(
      { error: 'Gagal mengambil pengaturan kipas' },
      { status: 500 }
    );
  }
}

export async function PUT(request: NextRequest) {
  try {
    const { is_auto_mode, fan_on_threshold_co2, fan_on_threshold_particulate, danger_threshold_co2, danger_threshold_particulate } =
      await request.json();

    const result = await pool.query(
      'UPDATE fan_settings SET is_auto_mode = $1, fan_on_threshold_co2 = $2, fan_on_threshold_particulate = $3, danger_threshold_co2 = $4, danger_threshold_particulate = $5, updated_at = CURRENT_TIMESTAMP WHERE id = 1 RETURNING *',
      [is_auto_mode, fan_on_threshold_co2, fan_on_threshold_particulate, danger_threshold_co2, danger_threshold_particulate]
    );

    return NextResponse.json(result.rows[0]);
  } catch (error) {
    console.error('Update fan settings error:', error);
    return NextResponse.json(
      { error: 'Gagal mengupdate pengaturan kipas' },
      { status: 500 }
    );
  }
}
