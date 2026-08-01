import React from 'react';
import { Box, Typography, Breadcrumbs, Link as MuiLink } from '@mui/material';
import { Link as RouterLink } from 'react-router-dom';

interface BreadcrumbItem {
  label: string;
  path?: string;
}

interface PageHeaderProps {
  title: string;
  subtitle?: string;
  breadcrumbs?: BreadcrumbItem[];
  actions?: React.ReactNode;
}

export const PageHeader: React.FC<PageHeaderProps> = ({
  title,
  subtitle,
  breadcrumbs,
  actions,
}) => {
  return (
    <Box sx={{ mb: 4, display: 'flex', flexDirection: { xs: 'column', sm: 'row' }, justifyContent: 'space-between', alignItems: { xs: 'flex-start', sm: 'center' }, gap: 2 }}>
      <Box>
        {breadcrumbs && breadcrumbs.length > 0 && (
          <Breadcrumbs separator="/" sx={{ mb: 1, fontSize: '0.8125rem' }}>
            {breadcrumbs.map((item, index) =>
              item.path ? (
                <MuiLink
                  key={index}
                  component={RouterLink}
                  to={item.path}
                  underline="hover"
                  color="text.secondary"
                >
                  {item.label}
                </MuiLink>
              ) : (
                <Typography key={index} color="text.primary" sx={{ fontSize: '0.8125rem', fontWeight: 500 }}>
                  {item.label}
                </Typography>
              )
            )}
          </Breadcrumbs>
        )}
        <Typography variant="h1" sx={{ fontSize: { xs: '1.5rem', sm: '1.75rem' }, fontWeight: 700, letterSpacing: '-0.02em' }}>
          {title}
        </Typography>
        {subtitle && (
          <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
            {subtitle}
          </Typography>
        )}
      </Box>
      {actions && <Box sx={{ display: 'flex', gap: 1.5, alignItems: 'center' }}>{actions}</Box>}
    </Box>
  );
};
