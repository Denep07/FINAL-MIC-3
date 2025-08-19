document.addEventListener('DOMContentLoaded', function() {
    const apiUrl = 'http://127.0.0.1:8000/padres/padres';
    const form = document.getElementById('padreForm');
    const tableBody = document.getElementById('padresTableBody');
    const messageDiv = document.getElementById('message');
    let editId = null;

    function showMessage(msg, type = 'success') {
        messageDiv.textContent = msg;
        messageDiv.className = 'message ' + type;
        setTimeout(() => { messageDiv.textContent = ''; }, 2500);
    }

    function clearForm() {
        form.reset();
        editId = null;
        form['submitBtn'].textContent = 'Agregar';
    }

    async function fetchPadres() {
        tableBody.innerHTML = '<tr><td colspan="7">Cargando...</td></tr>';
        const token = localStorage.getItem('token');
        try {
            const res = await fetch(apiUrl, {
                headers: {
                    'Authorization': 'Bearer ' + token
                }
            });
            let data;
            try { data = await res.json(); } catch { data = null; }
            if (data && data.error && (data.error.includes('Rol no autorizado') || data.error.includes('Permiso denegado') || data.error.includes('no permitido'))) {
                showMessage('Tu rol no tiene permitido realizar esta acción.', 'error');
                alert('Tu rol no tiene permitido realizar esta acción.');
                tableBody.innerHTML = '<tr><td colspan="7">Acceso denegado por rol</td></tr>';
                return;
            }
            tableBody.innerHTML = '';
            (data || []).forEach(padre => {
                tableBody.innerHTML += `
                <tr>
                    <td>${padre.codigo_tutor}</td>
                    <td>${padre.nombre_completo}</td>
                    <td>${padre.relacion_con_nino}</td>
                    <td>${padre.direccion || ''}</td>
                    <td>${padre.telefono || ''}</td>
                    <td>${padre.correo || ''}</td>
                    <td class="actions-btns">
                        <button onclick="editPadre(${padre.codigo_tutor}, '${padre.nombre_completo.replace(/'/g, "&#39;")}', '${padre.relacion_con_nino.replace(/'/g, "&#39;")}', '${(padre.direccion || '').replace(/'/g, "&#39;")}', '${(padre.telefono || '').replace(/'/g, "&#39;")}', '${(padre.correo || '').replace(/'/g, "&#39;")}')">Editar</button>
                        <button onclick="deletePadre(${padre.codigo_tutor})">Eliminar</button>
                    </td>
                </tr>`;
            });
        } catch {
            tableBody.innerHTML = '<tr><td colspan="7">Error al cargar datos</td></tr>';
        }
    }

    window.editPadre = function(id, nombre_completo, relacion_con_nino, direccion, telefono, correo) {
        editId = id;
        form.codigo_tutor.value = id;
        form.nombre_completo.value = nombre_completo;
        form.relacion_con_nino.value = relacion_con_nino;
        form.direccion.value = direccion;
        form.telefono.value = telefono;
        form.correo.value = correo;
        form['submitBtn'].textContent = 'Actualizar';
    }

    window.deletePadre = function(id) {
        if (confirm('¿Seguro que deseas eliminar este padre/tutor?')) {
            const token = localStorage.getItem('token');
            fetch(`${apiUrl}/${id}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': 'Bearer ' + token
                }
            })
            .then(async r => {
                let resp = null;
                try { resp = await r.json(); } catch {}
                if (r.ok) {
                    showMessage('Padre/tutor eliminado');
                    fetchPadres();
                    clearForm();
                } else if (resp && resp.error && (resp.error.includes('Rol no autorizado') || resp.error.includes('Permiso denegado') || resp.error.includes('no permitido'))) {
                    showMessage('Tu rol no tiene permitido realizar esta acción.', 'error');
                    alert('Tu rol no tiene permitido realizar esta acción.');
                } else {
                    showMessage('Error al eliminar', 'error');
                }
            })
            .catch(() => showMessage('Error al eliminar', 'error'));
        }
    }

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const data = {
            nombre_completo: form.nombre_completo.value,
            relacion_con_nino: form.relacion_con_nino.value,
            direccion: form.direccion.value,
            telefono: form.telefono.value,
            correo: form.correo.value
        };
        const token = localStorage.getItem('token');
        if (editId) {
            fetch(`${apiUrl}/${editId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + token
                },
                body: JSON.stringify(data)
            })
            .then(async r => {
                let resp = null;
                try { resp = await r.json(); } catch {}
                if (r.ok) {
                    showMessage('Padre/tutor actualizado');
                    fetchPadres();
                    clearForm();
                } else if (resp && resp.error && (resp.error.includes('Rol no autorizado') || resp.error.includes('Permiso denegado') || resp.error.includes('no permitido'))) {
                    showMessage('Tu rol no tiene permitido realizar esta acción.', 'error');
                    alert('Tu rol no tiene permitido realizar esta acción.');
                } else {
                    showMessage('Error al actualizar', 'error');
                }
            })
            .catch(() => showMessage('Error al actualizar', 'error'));
        } else {
            fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + token
                },
                body: JSON.stringify(data)
            })
            .then(async r => {
                let resp = null;
                try { resp = await r.json(); } catch {}
                if (r.status === 201 || r.ok) {
                    showMessage('Padre/tutor agregado');
                    fetchPadres();
                    clearForm();
                } else if (resp && resp.error && (resp.error.includes('Rol no autorizado') || resp.error.includes('Permiso denegado') || resp.error.includes('no permitido'))) {
                    showMessage('Tu rol no tiene permitido realizar esta acción.', 'error');
                    alert('Tu rol no tiene permitido realizar esta acción.');
                } else {
                    showMessage('Error al agregar', 'error');
                }
            })
        }
    });

    fetchPadres();
});