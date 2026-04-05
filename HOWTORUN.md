## Как запустить:
запускает базы данных и копирует данные
```bash
docker compose up
```

### Трансформация в звезду
```bash
docker cp ./scripts/star.sql trino:/tmp/star.sql
docker exec -it trino trino -f /tmp/star.sql
```

### Создание отчетов
```bash
docker cp ./scripts/datamarts.sql trino:/tmp/datamarts.sql
docker exec -it trino trino -f /tmp/datamarts.sql
```

### Запуск обоих
```bash
./run_trino.sh
```


