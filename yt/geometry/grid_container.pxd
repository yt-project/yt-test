"""
Matching points on the grid to specific grids



"""

#-----------------------------------------------------------------------------
# Copyright (c) 2013, yt Development Team.
#
# Distributed under the terms of the Modified BSD License.
#
# The full license is in the file COPYING.txt, distributed with this software.
#-----------------------------------------------------------------------------

import numpy as np
cimport numpy as np
cimport cython

from libc.stdlib cimport malloc, free
from yt.geometry.selection_routines cimport SelectorObject, _ensure_code
from yt.utilities.lib.fp_utils cimport iclip
from grid_visitors cimport GridTreeNode, GridTreeNodePadded
cimport grid_visitors 
from grid_visitors cimport GridVisitor, \
    CountGridCells, MaskGridCells, ICoordsGrids, IResGrids, FCoordsGrids, \
    FWidthGrids

cdef class GridTree:
    cdef GridTreeNode *grids
    cdef GridTreeNode *root_grids
    cdef int num_grids
    cdef int num_root_grids
    cdef int num_leaf_grids

cdef class GridTreeSelector:
    cdef GridTree tree
    cdef np.uint8_t[:] mask
    cdef np.uint8_t[:] grid_mask
    cdef public np.int64_t[:] grid_order
    cdef np.uint64_t size
    cdef np.uint64_t cell_count
    cdef np.uint8_t initialized
    cdef np.uint64_t _counter

    cdef void visit_grids(self, GridVisitor visitor, SelectorObject selector)
    cdef void recursively_visit_grid(self,
                          GridVisitor visitor,
                          SelectorObject selector,
                          GridTreeNode *grid)


cdef class MatchPointsToGrids:

    cdef int num_points
    cdef np.float64_t *xp
    cdef np.float64_t *yp
    cdef np.float64_t *zp
    cdef GridTree tree
    cdef np.int64_t *point_grids
    cdef np.uint8_t check_position(self,
                                   np.int64_t pt_index, 
                                   np.float64_t x,
                                   np.float64_t y,
                                   np.float64_t z,
                                   GridTreeNode *grid)

    cdef np.uint8_t is_in_grid(self,
			 np.float64_t x,
			 np.float64_t y,
			 np.float64_t z,
			 GridTreeNode *grid)

cdef extern from "platform_dep.h" nogil:
    double rint(double x)
