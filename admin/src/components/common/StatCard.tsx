import React from 'react';
import { Card, CardContent, Typography, Box } from '@mui/material';

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: React.ReactNode;
  trend?: string;
}

export const StatCard: React.FC<StatCardProps> = ({ title, value, subtitle, icon, trend }) => {
  return (
    <Card
      sx={{
        p: 1,
        borderRadius: '18px',
        border: '1px solid #E4E4E7',
        boxShadow: '0 2px 12px rgba(0,0,0,0.02)',
        transition: 'transform 0.2s ease, box-shadow 0.2s ease',
        '&:hover': {
          transform: 'translateY(-2px)',
          boxShadow: '0 6px 20px rgba(0,0,0,0.04)',
        },
      }}
    >
      <CardContent sx={{ p: 2.5, '&:last-child': { pb: 2.5 } }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Typography variant="subtitle2" color="text.secondary" sx={{ fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
            {title}
          </Typography>
          <Box
            sx={{
              p: 1,
              borderRadius: '12px',
              backgroundColor: '#F4F4F5',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#18181B',
            }}
          >
            {icon}
          </Box>
        </Box>
        <Typography variant="h2" sx={{ fontWeight: 700, mb: 0.5, fontSize: '2rem' }}>
          {value}
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
          {trend && (
            <Typography variant="caption" sx={{ color: '#16A34A', fontWeight: 600 }}>
              {trend}
            </Typography>
          )}
          {subtitle && (
            <Typography variant="caption" color="text.secondary">
              {subtitle}
            </Typography>
          )}
        </Box>
      </CardContent>
    </Card>
  );
};
