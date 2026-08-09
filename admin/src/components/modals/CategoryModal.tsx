import React, { useEffect } from 'react';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  Grid2 as Grid,
} from '@mui/material';
import { Category } from '../../types';

const categorySchema = z.object({
  name: z.string().min(1, 'Category name is required').max(100),
});

type CategoryFormData = z.infer<typeof categorySchema>;

interface CategoryModalProps {
  open: boolean;
  category: Category | null;
  loading?: boolean;
  onClose: () => void;
  onSubmit: (data: Partial<Category>) => Promise<void>;
}

export const CategoryModal: React.FC<CategoryModalProps> = ({
  open,
  category,
  loading = false,
  onClose,
  onSubmit,
}) => {
  const {
    control,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<CategoryFormData>({
    resolver: zodResolver(categorySchema),
    defaultValues: {
      name: '',
    },
  });

  useEffect(() => {
    if (category) {
      reset({
        name: category.name || '',
      });
    } else {
      reset({
        name: '',
      });
    }
  }, [category, reset, open]);

  const handleFormSubmit = async (data: CategoryFormData) => {
    await onSubmit({
      name: data.name,
      status: 'active',
      sortOrder: 0,
      icon: 'temple_hindu',
      description: '',
    });
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="xs" fullWidth PaperProps={{ sx: { borderRadius: '18px', p: 1 } }}>
      <DialogTitle sx={{ fontWeight: 700 }}>
        {category ? 'Edit Category' : 'Create New Category'}
      </DialogTitle>
      <form onSubmit={handleSubmit(handleFormSubmit)}>
        <DialogContent>
          <Grid container spacing={2}>
            <Grid size={{ xs: 12 }}>
              <Controller
                name="name"
                control={control}
                render={({ field }) => (
                  <TextField
                    {...field}
                    label="Category Name *"
                    fullWidth
                    autoFocus
                    error={!!errors.name}
                    helperText={errors.name?.message}
                  />
                )}
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={onClose} disabled={loading} variant="outlined" color="inherit">
            Cancel
          </Button>
          <Button type="submit" disabled={loading} variant="contained">
            {loading ? 'Saving...' : category ? 'Update Category' : 'Create Category'}
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};
