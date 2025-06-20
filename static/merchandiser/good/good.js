// =============================================
// MAIN INITIALIZATION
// =============================================
document.addEventListener('DOMContentLoaded', async () => {
  // Initialize application components
  setupResizableBlocks();
  await initializeApplication();
});

// =============================================
// RESIZABLE BLOCKS FUNCTIONALITY
// =============================================
const setupResizableBlocks = () => {
  const container = document.querySelector('.form-container');
  const formBlock = document.querySelector('#form-block');
  const tableBlock = document.querySelector('#table-block');
  const resizeHandle = document.querySelector('.resize-handle');

  if (!container || !formBlock || !tableBlock || !resizeHandle) return;

  let isResizing = false;
  let startY = 0;
  let startFormHeight = 0;

  const handleMouseMove = e => {
    if (!isResizing) return;
    const dy = e.clientY - startY;
    const containerHeight = container.offsetHeight;
    const handleHeight = resizeHandle.offsetHeight;
    const availableHeight = containerHeight - handleHeight;
    let newFormHeight = Math.max(0, Math.min(startFormHeight + dy, availableHeight));
    const formPercent = (newFormHeight / availableHeight) * 100;
    formBlock.style.flex = `0 0 ${formPercent}%`;
    tableBlock.style.flex = `0 0 ${100 - formPercent}%`;
  };

  const handleMouseUp = () => {
    isResizing = false;
    document.body.style.cursor = '';
    document.body.style.userSelect = '';
  };

  resizeHandle.addEventListener('mousedown', e => {
    isResizing = true;
    startY = e.clientY;
    startFormHeight = formBlock.offsetHeight;
    document.body.style.cursor = 'row-resize';
    document.body.style.userSelect = 'none';
    e.preventDefault();
  });

  document.addEventListener('mousemove', handleMouseMove);
  document.addEventListener('mouseup', handleMouseUp);
};

// =============================================
// APPLICATION CORE
// =============================================
const initializeApplication = async () => {
  // Application state
  const state = {
    selectedRow: null,
    dropdownData: null,
    goodsData: [],
    currentSortState: { key: '', direction: 'asc' }
  };

  // Initialize components
  await initDropdowns(state);
  setupTableSorting(state);
  await loadGoodsTable(state);
  setupColumnResizing();
  setupEventListeners(state);
};

// =============================================
// DROPDOWN MANAGEMENT
// =============================================
const initDropdowns = async (state) => {
  try {
    const response = await fetch('/get_create_good_data');
    if (!response.ok) throw new Error('Failed to load dropdown data');
    state.dropdownData = await response.json();
    populateDropdowns(state.dropdownData);
  } catch (error) {
    console.error('Dropdown initialization error:', error);
    alert('Failed to initialize form data. Please refresh the page.');
  }
};

const populateDropdowns = (dropdownData) => {
  populateDropdown('unit', dropdownData.unit);
  populateDropdown('vac', dropdownData.vac);
  populateDropdown('group', dropdownData.group);
};

const populateDropdown = (id, options) => {
  const dropdown = document.getElementById(id);
  dropdown.innerHTML = '';
  for (const [value, text] of Object.entries(options)) {
    const option = document.createElement('option');
    option.value = value;
    option.textContent = text;
    dropdown.appendChild(option);
  }
};

// =============================================
// TABLE SORTING
// =============================================
const setupTableSorting = (state) => {
  const table = document.querySelector('#show-good-table');
  if (!table) return;

  const thElements = table.querySelectorAll('thead th');
  const sortKeys = ['active', 'name', 'code', 'unit', 'uktzed', 'vac', 'excise', 'group'];

  thElements.forEach((th, index) => {
    const sortKey = sortKeys[index];
    th.style.cursor = 'pointer';

    // Очищаємо текст заголовка від стрілочок
    const headerText = th.textContent.replace(/[▲▼]/g, '').trim();
    th.textContent = headerText;

    const indicator = document.createElement('span');
    indicator.className = 'sort-indicator';
    th.appendChild(indicator);

    th.addEventListener('click', () => {
      // Визначаємо новий напрямок сортування
      const newDirection = state.currentSortState.key === sortKey &&
                          state.currentSortState.direction === 'asc'
                          ? 'desc' : 'asc';

      // Оновлюємо стан сортування
      state.currentSortState = {
        key: sortKey,
        direction: newDirection
      };

      // Оновлюємо індикатори
      thElements.forEach(t => {
        const ind = t.querySelector('.sort-indicator');
        ind.textContent = '';
      });

      indicator.textContent = newDirection === 'asc' ? '▲' : '▼';

      // Сортуємо і відображаємо
      sortAndRenderGoodsTable(state);
    });
  });
};

const sortData = (data, key, direction) => {
  return [...data].sort((a, b) => {
    let valA = a[key];
    let valB = b[key];

    if (key === 'active' || key === 'excise') {
      valA = valA ? 1 : 0;
      valB = valB ? 1 : 0;
    } else if (typeof valA === 'string') {
      valA = valA.toLowerCase();
      valB = valB.toLowerCase();
    }

    return direction === 'asc' ?
      valA > valB ? 1 : -1 :
      valA < valB ? 1 : -1;
  });
};

// =============================================
// GOODS TABLE MANAGEMENT
// =============================================
const loadGoodsTable = async (state) => {
  try {
    const response = await fetch('/show_good');
    if (!response.ok) throw new Error('Failed to load goods');

    const result = await response.json();
    if (!result.success) throw new Error(result.error || 'Unknown error loading goods');

    state.goodsData = result.data;
    sortAndRenderGoodsTable(state);
  } catch (error) {
    console.error('Table load error:', error);
    alert(`Error loading goods: ${error.message}`);
  }
};

const sortAndRenderGoodsTable = (state) => {
  if (!state.currentSortState.key) {
    renderGoodsTable(state.goodsData, state);
    return;
  }

  const sortedData = sortData(state.goodsData, state.currentSortState.key, state.currentSortState.direction);
  renderGoodsTable(sortedData, state);
};

const renderGoodsTable = (goods, state) => {
  const tbody = document.querySelector('#show-good-table tbody');
  tbody.innerHTML = '';

  goods.forEach(good => {
    const row = document.createElement('tr');
    row.dataset.id = good.id;
    row.dataset.active = good.active;
    row.innerHTML = `
      <td><span class="status-indicator ${good.active ? 'status-active' : 'status-inactive'}"></span></td>
      <td>${good.name}</td>
      <td>${good.code || ''}</td>
      <td>${good.unit}</td>
      <td>${good.uktzed || ''}</td>
      <td>${good.vac}</td>
      <td>${good.excise ? 'Yes' : 'No'}</td>
      <td>${good.group}</td>
    `;
    tbody.appendChild(row);
  });

  // Add row selection/unselection
  tbody.querySelectorAll('tr').forEach(row => {
    row.addEventListener('click', () => handleRowClick(row, state));
  });
};

const handleRowClick = (row, state) => {
  // Unselect if clicking the same row
  if (state.selectedRow === row) {
    row.classList.remove('selected-row');
    state.selectedRow = null;
    resetForm();
    return;
  }

  // Remove previous selection
  if (state.selectedRow) {
    state.selectedRow.classList.remove('selected-row');
  }

  // Set new selection
  row.classList.add('selected-row');
  state.selectedRow = row;
  document.getElementById('delete-btn').style.display = 'inline-block';

  // Populate form
  populateFormFromRow(row, state.dropdownData);
};

const populateFormFromRow = (row, dropdownData) => {
  document.getElementById('good_id').value = row.dataset.id;
  document.getElementById('name').value = row.cells[1].textContent;
  document.getElementById('code').value = row.cells[2].textContent;
  document.getElementById('uktzed').value = row.cells[4].textContent;
  document.getElementById('excise').checked = row.cells[6].textContent === 'Yes';
  document.getElementById('active').checked = row.dataset.active === "1" ? true : false;

  // Set dropdowns using cached data
  setDropdownValue('unit', row.cells[3].textContent, dropdownData.unit);
  setDropdownValue('vac', row.cells[5].textContent, dropdownData.vac);
  setDropdownValue('group', row.cells[7].textContent, dropdownData.group);
};

const setDropdownValue = (id, text, options) => {
  const dropdown = document.getElementById(id);
  // Find key by text value
  const entry = Object.entries(options).find(([key, val]) => val === text);
  if (entry) {
    dropdown.value = entry[0];
  }
};

// =============================================
// FORM HANDLING
// =============================================
const setupEventListeners = (state) => {
  // Form submission handler
  document.getElementById('create-good-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    await handleFormSubmit(state);
  });

  // Delete button handler
  document.getElementById('delete-btn').addEventListener('click', async () => {
    await handleDelete(state);
  });
};

const handleFormSubmit = async (state) => {
  const submitBtn = document.getElementById('submit-btn');
  submitBtn.disabled = true;

  try {
    const formData = {
      id: document.getElementById('good_id').value,
      name: document.getElementById('name').value,
      code: document.getElementById('code').value,
      unit: document.getElementById('unit').value,
      uktzed: document.getElementById('uktzed').value || null,
      vac: document.getElementById('vac').value,
      excise: document.getElementById('excise').checked,
      active: document.getElementById('active').checked,
      group: document.getElementById('group').value
    };

    const endpoint = formData.id ? '/update_good' : '/create_good';

    const response = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(formData)
    });

    const result = await response.json();
    if (!result.success) {
      throw new Error(result.error || 'Operation failed');
    }

    resetForm();
    await loadGoodsTable(state);
  } catch (error) {
    console.error('Submit error:', error);
    alert(`Error: ${error.message}`);
  } finally {
    submitBtn.disabled = false;
  }
};

const handleDelete = async (state) => {
  const goodId = document.getElementById('good_id').value;
  if (!goodId) return;

  if (!confirm('Are you sure you want to delete this product?')) {
    return;
  }

  const deleteBtn = document.getElementById('delete-btn');
  deleteBtn.disabled = true;

  try {
    const response = await fetch(`/delete_good/${goodId}`, {
      method: 'DELETE'
    });

    const result = await response.json();
    if (!result.success) {
      throw new Error(result.error || 'Delete failed');
    }

    resetForm();
    await loadGoodsTable(state);
  } catch (error) {
    console.error('Delete error:', error);
    alert(`Delete failed: ${error.message}`);
  } finally {
    deleteBtn.disabled = false;
  }
};

const resetForm = () => {
  document.getElementById('create-good-form').reset();
  document.getElementById('good_id').value = '';
  document.getElementById('delete-btn').style.display = 'none';
  const selectedRow = document.querySelector('.selected-row');
  if (selectedRow) {
    selectedRow.classList.remove('selected-row');
  }
};

// =============================================
// COLUMN RESIZING WITH PERSISTENCE
// =============================================
const setupColumnResizing = () => {
  const table = document.getElementById('show-good-table');
  if (!table) return;

  const ths = table.querySelectorAll('th');
  const COLUMN_WIDTHS_KEY = 'tableColumnWidths';

  // Функція для збереження ширини колонок
  const saveColumnWidths = () => {
    const widths = {};
    ths.forEach((th, index) => {
      widths[index] = th.style.width || th.offsetWidth + 'px';
    });
    localStorage.setItem(COLUMN_WIDTHS_KEY, JSON.stringify(widths));
  };

  // Функція для завантаження збережених ширини колонок
  const loadColumnWidths = () => {
    const savedWidths = localStorage.getItem(COLUMN_WIDTHS_KEY);
    if (!savedWidths) return null;

    try {
      return JSON.parse(savedWidths);
    } catch (e) {
      console.error('Failed to parse saved column widths', e);
      return null;
    }
  };

  // Визначаємо мінімальні ширини на основі тексту заголовків
  const calculateHeaderWidths = () => {
    const widths = [];
    ths.forEach(th => {
      const span = document.createElement('span');
      span.textContent = th.textContent.replace(/[▲▼]/g, '').trim();
      span.style.visibility = 'hidden';
      span.style.position = 'absolute';
      span.style.whiteSpace = 'nowrap';
      document.body.appendChild(span);
      widths.push(span.offsetWidth + 40); // +40px для відступів та стрілочки
      document.body.removeChild(span);
    });
    return widths;
  };

  const minWidths = calculateHeaderWidths();
  const savedWidths = loadColumnWidths();

  ths.forEach((th, index) => {
    // Застосовуємо збережені ширини, якщо вони є
    if (savedWidths && savedWidths[index]) {
      th.style.width = savedWidths[index];

      // Оновлюємо всі комірки в колонці
      const allCells = table.querySelectorAll(`td:nth-child(${index + 1})`);
      allCells.forEach(cell => {
        cell.style.width = savedWidths[index];
      });
    }

    const resizer = document.createElement('div');
    resizer.classList.add('resizer');
    th.appendChild(resizer);

    let isResizing = false;
    let startX, startWidth;

    resizer.addEventListener('mousedown', (e) => {
      isResizing = true;
      startX = e.clientX;
      startWidth = th.offsetWidth;
      document.body.style.cursor = 'col-resize';
      document.body.style.userSelect = 'none';
      e.preventDefault();
    });

    document.addEventListener('mousemove', (e) => {
      if (!isResizing) return;

      let newWidth = startWidth + (e.clientX - startX);

      // Не дозволяємо зробити колонку вужчою за заголовок
      if (newWidth < minWidths[index]) {
        newWidth = minWidths[index];
      }

      th.style.width = `${newWidth}px`;

      // Оновлюємо всі комірки в колонці
      const allCells = table.querySelectorAll(`td:nth-child(${index + 1})`);
      allCells.forEach(cell => {
        cell.style.width = `${newWidth}px`;
      });
    });

    document.addEventListener('mouseup', () => {
      if (isResizing) {
        isResizing = false;
        document.body.style.cursor = '';
        document.body.style.userSelect = '';
        saveColumnWidths(); // Зберігаємо нові ширини після зміни
      }
    });
  });
};