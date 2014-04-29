from django.db import models


# Create your models here.
class Picture(models.Model):
    title = models.CharField(max_length=200)
    desc = models.CharField(max_length=3000)
    dateTime = models.DateTimeField(blank=True, null=True, auto_now=True)
    url = models.CharField(max_length=400)