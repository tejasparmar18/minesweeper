# frozen_string_literal: true

module BoardsHelper
  def render_cells(cells)
    cells.map { |cell| render_cell(cell) }.join('').html_safe
  end

  def render_cell(cell)
    content_tag(:div, class: 'text-center bg-light border items-center h4 align-middle align-self-center mb-0',
                      style: 'width: 40px;') do
      render_cell_content(cell)
    end
  end

  def render_cell_content(cell)
    if cell.mine
      content_tag(:span, '💣', class: 'mine')
    elsif cell.close_mines.zero?
      '&nbsp;'.html_safe
    else
      content_tag(:span, cell.close_mines, class: 'close-mines')
    end
  end
end
