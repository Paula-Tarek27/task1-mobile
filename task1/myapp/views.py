from django.shortcuts import render
from rest_framework import generics 
from .models import MyModel
from .serializers import MyModelSerializer

# Create your views here.
class MyModelListCreateView(generics.ListCreateAPIView):
    queryset = MyModel.objects.all()
    serializer_class = MyModelSerializer

class MyModelRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = MyModel.objects.all()
    serializer_class = MyModelSerializer