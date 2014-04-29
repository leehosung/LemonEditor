from django.shortcuts import render
from galleryApp.models import *
from django.shortcuts import redirect, render, render_to_response


def index(request):
    mainPicture = Picture.all().order_by('-datetime')[0]
    pictures = Picture.all().order_by('-user__date_joined')[1:16]
    return render(request, 'index.html', {'mainPicture': mainPicture, 'pictures': pictures})


def page(request, pageIndex):
    startPage = (pageIndex-1) * 16
    endPage = pageIndex * 16
    pictures = Picture.all()[startPage:endPage]
    countOfPage = Picture.all().count()/16
    return render(request, 'page.html', {'countOfPage': countOfPage, 'pictures': pictures})

def register(request):
    return render(request, 'register.html')