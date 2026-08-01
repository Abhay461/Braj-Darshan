import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { categoryApi } from '../api/categoryApi';
import { Category, QueryParams } from '../types';
import { useSnackbar } from 'notistack';

export const useCategories = (params?: QueryParams) => {
  return useQuery({
    queryKey: ['categories', params],
    queryFn: () => categoryApi.getCategories(params),
  });
};

export const useCategoryMutations = () => {
  const queryClient = useQueryClient();
  const { enqueueSnackbar } = useSnackbar();

  const createMutation = useMutation({
    mutationFn: (data: Partial<Category>) => categoryApi.createCategory(data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
      enqueueSnackbar(res.message || 'Category created', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<Category> }) => categoryApi.updateCategory(id, data),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
      enqueueSnackbar(res.message || 'Category updated', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => categoryApi.deleteCategory(id),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['categories'] });
      enqueueSnackbar(res.message || 'Category deleted', { variant: 'success' });
    },
    onError: (err: Error) => enqueueSnackbar(err.message, { variant: 'error' }),
  });

  return {
    createCategory: createMutation.mutateAsync,
    updateCategory: updateMutation.mutateAsync,
    deleteCategory: deleteMutation.mutateAsync,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
  };
};
