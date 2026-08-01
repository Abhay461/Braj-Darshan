import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Grid2 as Grid,
  Button,
  Divider,
} from '@mui/material';
import DownloadIcon from '@mui/icons-material/DownloadOutlined';
import UploadIcon from '@mui/icons-material/FileUploadOutlined';
import BackupIcon from '@mui/icons-material/BackupOutlined';

import { PageHeader } from '../../components/common/PageHeader';
import { ImportModal } from '../../components/modals/ImportModal';
import { useTemples, useTempleMutations } from '../../hooks/useTemples';
import { useCategories } from '../../hooks/useCategories';
import { useLocations } from '../../hooks/useLocations';
import { exportToJson } from '../../utils/csvHelper';
import { useSnackbar } from 'notistack';
import { Temple } from '../../types';

export const BackupImportExport: React.FC = () => {
  const [importOpen, setImportOpen] = useState(false);
  const { data: templesRes } = useTemples({ limit: 1000 });
  const { data: categoriesRes } = useCategories();
  const { data: locationsRes } = useLocations();
  const { createTemple } = useTempleMutations();
  const { enqueueSnackbar } = useSnackbar();

  const handleExportTemples = () => {
    const data = templesRes?.data || [];
    exportToJson(data, `braj_darshan_temples_backup_${Date.now()}`);
    enqueueSnackbar('Temples exported successfully as JSON backup', { variant: 'success' });
  };

  const handleExportFullDatabase = () => {
    const fullBackup = {
      temples: templesRes?.data || [],
      categories: categoriesRes?.data || [],
      locations: locationsRes?.data || [],
      timestamp: new Date().toISOString(),
    };
    exportToJson(fullBackup, `braj_darshan_full_backup_${Date.now()}`);
    enqueueSnackbar('Full platform database exported successfully', { variant: 'success' });
  };

  const handleBulkImport = async (importData: Partial<Temple>[]) => {
    for (const item of importData) {
      if (categoriesRes?.data?.[0]?._id && locationsRes?.data?.[0]?._id) {
        item.categoryId = item.categoryId || categoriesRes.data[0]._id;
        item.locationId = item.locationId || locationsRes.data[0]._id;
      }
      await createTemple(item);
    }
  };

  return (
    <Box>
      <PageHeader
        title="Backup, Import & Export"
        subtitle="Export platform database backups or perform bulk temple imports via CSV/JSON"
        breadcrumbs={[{ label: 'Dashboard', path: '/' }, { label: 'Backup & Import' }]}
      />

      <Grid container spacing={3}>
        {/* Export Backup Card */}
        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1, height: '100%' }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 2 }}>
                <DownloadIcon sx={{ fontSize: 28 }} />
                <Typography variant="h4" sx={{ fontWeight: 700 }}>
                  Export Database Backup
                </Typography>
              </Box>
              <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
                Download platform data as JSON files for off-site backup or migration.
              </Typography>

              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Button
                  variant="contained"
                  startIcon={<BackupIcon />}
                  onClick={handleExportFullDatabase}
                  fullWidth
                  sx={{ py: 1.5 }}
                >
                  Export Full Database Backup (JSON)
                </Button>
                <Button
                  variant="outlined"
                  startIcon={<DownloadIcon />}
                  onClick={handleExportTemples}
                  fullWidth
                  sx={{ py: 1.5 }}
                >
                  Export Temples Only (JSON)
                </Button>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Bulk Import Card */}
        <Grid size={{ xs: 12, md: 6 }}>
          <Card sx={{ p: 1, height: '100%' }}>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1.5, mb: 2 }}>
                <UploadIcon sx={{ fontSize: 28 }} />
                <Typography variant="h4" sx={{ fontWeight: 700 }}>
                  Bulk Import Shrines
                </Typography>
              </Box>
              <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
                Upload multiple temples simultaneously using formatted CSV or JSON files.
              </Typography>

              <Button
                variant="contained"
                startIcon={<UploadIcon />}
                onClick={() => setImportOpen(true)}
                fullWidth
                sx={{ py: 1.5 }}
              >
                Launch Bulk Import Wizard
              </Button>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <ImportModal
        open={importOpen}
        onClose={() => setImportOpen(false)}
        onImport={handleBulkImport}
      />
    </Box>
  );
};
