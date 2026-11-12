const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

let trails = [
  { id: '1', name: 'Ущелье Ала-Арча — Ак-Сай', altitude: 2800, difficulty: 'Средняя', isCompleted: true, notes: 'Отличная тропа, выходить лучше рано утром.' },
  { id: '2', name: 'Хижина Рацека (Ratsek Hut)', altitude: 3300, difficulty: 'Сложная', isCompleted: false, notes: 'Нужны треккинговые палки и тёплая куртка.' },
  { id: '3', name: 'Панорама Чункурчак', altitude: 2400, difficulty: 'Лёгкая', isCompleted: true, notes: 'Идеально для прогулки выходного дня.' },
  { id: '4', name: 'Озеро Кель-Суу', altitude: 3514, difficulty: 'Сложная', isCompleted: false, notes: 'Нужен погранпропуск и внедорожник.' },
];

app.get('/api/trails', (req, res) => {
  const { filter, search } = req.query;
  let result = [...trails];

  if (filter === 'completed') result = result.filter(t => t.isCompleted);
  if (filter === 'planned') result = result.filter(t => !t.isCompleted);
  
  if (search) {
    const query = search.toLowerCase();
    result = result.filter(t => t.name.toLowerCase().includes(query));
  }

  setTimeout(() => res.json(result), 400); 
});

app.post('/api/trails', (req, res) => {
  const { name, altitude, difficulty, notes } = req.body;
  if (!name) return res.status(400).json({ error: 'Название обязательно' });

  const newTrail = {
    id: Date.now().toString(),
    name,
    altitude: Number(altitude) || 2000,
    difficulty: difficulty || 'Средняя',
    isCompleted: false,
    notes: notes || ''
  };
  
  trails.unshift(newTrail);
  res.status(201).json(newTrail);
});

app.patch('/api/trails/:id/toggle', (req, res) => {
  const trail = trails.find(t => t.id === req.params.id);
  if (!trail) return res.status(404).json({ error: 'Маршрут не найден' });
  
  trail.isCompleted = !trail.isCompleted;
  res.json(trail);
});

app.delete('/api/trails/:id', (req, res) => {
  trails = trails.filter(t => t.id !== req.params.id);
  res.status(204).send();
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend server is running on http://localhost:${PORT}`);
});
