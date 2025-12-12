from django.http import HttpResponse


def health(request):
    return HttpResponse("Healthy!", status=200)
