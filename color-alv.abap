
type-pools slis.

types:
  begin of ty_mara,
    matnr  type mara-matnr,
    maktx  type makt-maktx,
    tcolor type slis_t_specialcol_alv,
  end of ty_mara .

data: gt_mara  type table of ty_mara,
      gs_mara  type          ty_mara,
      ls_color type slis_specialcol_alv,
      fieldcat type slis_t_fieldcat_alv .

start-of-selection.

  perform get_data.
  perform write_report.


************************************************************************
*  Get_Data
************************************************************************
form get_data.

* Para mostrar todas as cores disponiveis
  do 5 times .

    gs_mara-matnr = 'ABC'.
    gs_mara-maktx = 'This is description for ABC'.
    append gs_mara to gt_mara .

    gs_mara-matnr = 'DEF'.
    gs_mara-maktx = 'This is description for DEF'.
    append gs_mara to gt_mara .

  enddo .

  loop at gt_mara into gs_mara .

      ls_color-fieldname = 'MAKTX'.
      ls_color-color-col = ( sy-tabix - 1 ) .
      ls_color-color-int = '1'. "Negrito on/off
      ls_color-color-inv = '0'.

      append ls_color to gs_mara-tcolor .
      clear  ls_color .

      modify gt_mara from gs_mara .

  endloop.

endform.                    "get_data

************************************************************************
*  WRITE_REPORT
************************************************************************
form write_report.

  data: layout type  slis_layout_alv.

  layout-coltab_fieldname = 'TCOLOR'.

  perform build_field_catalog.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      is_layout   = layout
      it_fieldcat = fieldcat
    tables
      t_outtab    = gt_mara .

endform.                    "write_report

************************************************************************
* BUILD_FIELD_CATALOG
************************************************************************
form build_field_catalog.

  data: ls_fieldcat type slis_fieldcat_alv .
* data: ls_fieldcat type slis_t_fieldcat_alv with header line.
  refresh: fieldcat.

  ls_fieldcat-reptext_ddic    = 'Material Number'.
  ls_fieldcat-fieldname       = 'MATNR'.
  ls_fieldcat-tabname         = 'GT_MARA'.
  ls_fieldcat-outputlen       = '18'.
  ls_fieldcat-col_pos         = 2.
  append ls_fieldcat to fieldcat .
  clear  ls_fieldcat .

  ls_fieldcat-reptext_ddic    = 'Material'.
  ls_fieldcat-fieldname       = 'MAKTX'.
  ls_fieldcat-tabname         = 'GT_MARA'.
  ls_fieldcat-outputlen       = '40'.
  ls_fieldcat-col_pos         = 3.
  append ls_fieldcat to fieldcat .
  clear  ls_fieldcat .

endform.                    "build_field_catalog
