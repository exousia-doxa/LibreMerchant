Merchandiser.onPageActivation('group_page', () => {
    const context = document.getElementById('group_page');

    // Initialize resizable blocks
    Merchandiser.setupResizable(context);

    // Table rendering
    const renderTable = data => {
        context.querySelector('#show-group-table tbody').innerHTML = data.map(group => `
            <tr>
                <td>${group.name}</td>
                <td>${group.type}</td>
                <td>${group.supergroup}</td>
            </tr>
        `).join('');
    };

    // Table sorting
    Merchandiser.setupTableSorting(
        '#show-group-table',
        ['name', 'type', 'supergroup'],
        'groupData',
        renderTable
    );

    // Initial data load
    fetch('/show_group')
        .then(res => res.json())
        .then(({ data }) => {
            window.groupData = data;
            renderTable(data);
        });

    // Form setup
    fetch('/get_create_group_data')
        .then(res => res.json())
        .then(({ group_id }) => {
            const select = context.querySelector('#supergroup');
            select.innerHTML = Object.entries(group_id)
                .map(([id, name]) => `<option value="${id}">${name} (${id-1})</option>`)
                .join('');
        });

    Merchandiser.setupForm('create-group-form', '/create_group', () => {
        fetch('/show_group')
            .then(res => res.json())
            .then(({ data }) => {
                window.groupData = data;
                renderTable(data);
            });
    });
});